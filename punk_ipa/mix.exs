defmodule PunkIpa.MixProject do
  use Mix.Project

  def project do
    [
      app: :punk_ipa,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PunkIpa.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:raw_sqlite3, "~> 1.0"}
    ]
  end
end
