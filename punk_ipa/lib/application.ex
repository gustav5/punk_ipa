defmodule PunkIpa.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [PunkIpa]

    opts = [strategy: :one_for_one, name: PunkIpa.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
