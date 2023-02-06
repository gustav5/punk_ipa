defmodule FrontWeb.Router do
  use FrontWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FrontWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrontWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/search", SearchLive

    live "/paginate", PaginateLive
    live "/info/:brand", InfoLive

    #live "/info/:brand", InfoLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrontWeb do
  #   pipe_through :api
  # end
end
