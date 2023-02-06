defmodule PunkIpa.Store do
  require Logger

  def store_data(data) do
    connect_to_database()
    |> create_tables_if_not_exists()
    |> store_data_rec(data)

    Logger.info("Data stored")
  end

  def get_data() do
    connect_to_database()
    |> :raw_sqlite3.q(
      "SELECT beer.name, beer.description, beer.abv, beer.yeast, food_pairing.food_pairing FROM beer
      JOIN food_pairing
      ON beer.name=food_pairing.name;"
    )
    |> Enum.group_by(fn {name, _description, _abv, _yeast, _food_pairing} ->
      name
    end)
    |> Enum.map(fn {_key, value} ->
      %{
        name: elem(List.first(value), 0),
        description: elem(List.first(value), 1),
        abv: elem(List.first(value), 2),
        yeast: elem(List.first(value), 3),
        food_pairing: Enum.map(value, fn {_, _, _, _, food_pairing} -> food_pairing end)
      }
    end)
  end

  def store_data_rec(db, data) do
    data
    |> Enum.map(fn x ->
      insert_or_update_beer(db, x)
      insert_or_update_food_paring(db, x)
    end)
  end

  def connect_to_database() do
    {:ok, db} = :raw_sqlite3.open("../punk_ipa/database1.db")
    db
  end

  def create_tables_if_not_exists(db) do
    :raw_sqlite3.exec(
      db,
      "CREATE TABLE IF NOT EXISTS beer (name TEXT, description TEXT, abv INTEGER, yeast TEXT, UNIQUE(name, description, abv));"
    )

    :raw_sqlite3.exec(
      db,
      "CREATE TABLE IF NOT EXISTS food_pairing (name TEXT, food_pairing TEXT, UNIQUE(name, food_pairing));"
    )

    db
  end

  def insert_or_update_beer(db, %{name: name, description: description, abv: abv, yeast: yeast}) do
    :raw_sqlite3.exec(
      db,
      "INSERT or ignore INTO beer(name, description, abv, yeast) VALUES('#{name}', '#{description}', #{abv}, '#{yeast}');"
    )
  end

  def insert_or_update_food_paring(db, %{name: name, food_pairing: food_pairing}) do
    food_pairing
    |> Enum.map(fn x ->
      :raw_sqlite3.exec(
        db,
        "INSERT or ignore INTO food_pairing(name, food_pairing) VALUES('#{name}', '#{x}');"
      )
    end)
  end
end
