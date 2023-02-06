defmodule PunkIpa do
  require Logger
  use GenServer

  alias PunkIpa.{Api, Store}

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get_beer(name, page) do
    GenServer.call(__MODULE__, {:get_beer, name, page})
  end

  def more_info(name) do
    GenServer.call(__MODULE__, {:more_info, name})
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  # Server (callbacks)

  @impl true
  def init(_init_args) do
    {:ok, state} = update_state()
    schedule_work(state)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get_beer, choosen_name, page}, _from, state) do
    list =
      state
      |> search_beers(choosen_name)
      |> Enum.map(fn map -> %{namn: map.name, alkoholhalt: map.abv} end)
      |> select_page(page)

    {:reply, list, state}
  end

  @impl true
  def handle_call({:more_info, chosen_name}, _from, state) do
    map =
      state
      |> search_beers(chosen_name)
      |> List.first()

    {:reply, %{name: chosen_name, description: map.description, food_pairing: Enum.join(map.food_pairing,", ")},
     state}
  end

  @impl true
  def handle_info(:daily_update, _state) do
    {:ok, new_state} = update_state()
    {:noreply, new_state}
  end

  defp schedule_work(state) do
    with {:ok, millisecs} <- ms_to_next_instance(%{update_at: "12:00:00"}),
         :ok <- Logger.info("State will update in #{convert_to_hours(millisecs)} hours.") do
      Process.send_after(__MODULE__, :update, millisecs)
      {:ok, state}
    else
      {:error, reason} ->
        Logger.warning("Can't perform daily update. Error message: #{inspect(reason)}")
    end
  end

  defp update_state() do
    case Api.get_data() do
      {:ok, raw_data} ->
        Store.store_data(raw_data)
        state = Store.get_data()
        {:ok, state}

      {:error, reason} ->
        Logger.warning("Can not get data. Error message: #{inspect(reason)}")
    end
  end

  defp ms_to_next_instance(%{update_at: time}) do
    {:ok, update_time} = Time.from_iso8601(time)
    time_diff = Time.diff(update_time, Time.utc_now(), :millisecond)

    if time_diff >= 0 do
      {:ok, time_diff}
    else
      {:ok, 86_400 * 1_000 + time_diff}
    end
  end

  defp convert_to_hours(millisecs) do
    (millisecs / 1000 / 60 / 60)
    |> Float.round(3)
    |> Float.to_string()
  end

  defp search_beers(state, phrase) do
    Enum.filter(state, fn %{name: name, description: description, yeast: yest} ->
      phrase = String.downcase(phrase)

      cond do
        String.contains?(String.downcase(name), phrase) -> true
        String.contains?(String.downcase(description), phrase) -> true
        String.contains?(String.downcase(yest), phrase) -> true
        true -> false
      end
    end)
  end

  defp select_page(list, page) do
    list
    |> Enum.take(10 * page)
    |> Enum.drop(10 * (page - 1))
  end
end
