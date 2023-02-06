defmodule PunkFront do
  use GenServer

  # Client

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def get_count() do
    GenServer.call(__MODULE__, :get_count)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    IO.puts("Skriv 'PunkFront.start' och tryck enter för att starta: \n")
    {:ok, state}
  end

  def start() do
    count = get_count()
    phrase =
      IO.gets("Sök på en öl:\n")
      |> String.replace("\n","")
      |> search(count)
  end

  def search(phrase, count) do
    list = PunkIpa.get_beer(phrase)
    case length(list) > 10 do
      true ->
        Enum.take(list,10)
      false ->
        list
    end
  end

  def hantera_input() do
    input = IO.gets("input val:
    Mer info om öl: skriv ölens namn
    Nästa sida: 'n'
    avbryt och sök igen: 'a'
    \n")

    input
    |> IO.gets("Sök på en öl:\n")
    |> case do
        "a" -> start()
       end

  end



  @impl true
  def handle_info(:work, state) do
    IO.inspect("hrllo")
    IO.gets("test:\n") |> IO.inspect(label: "29: ")

    {:noreply, state}
  end

  defp schedule_work(state) do
    Process.send_after(__MODULE__, :work, 10)
    {:ok, state}

  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:get_count, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
