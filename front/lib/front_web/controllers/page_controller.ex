defmodule FrontWeb.PageController do
  use FrontWeb, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end

  def info(conn, params) do
    render(conn, "index.html")
  end
end
