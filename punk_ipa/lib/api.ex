defmodule PunkIpa.Api do
  def request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_data() do
    case request("https://api.punkapi.com/v2/beers") do
      {:ok, body} ->
        result =
          body
          |> Jason.decode!()
          |> Enum.map(fn x ->
            %{
              name: Map.get(x, "name"),
              abv: Map.get(x, "abv"),
              description: Map.get(x, "description"),
              yeast: Kernel.get_in(x, ["ingredients", "yeast"]),
              food_pairing: Map.get(x, "food_pairing")
            }
          end)

        {:ok, result}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
