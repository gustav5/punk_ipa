defmodule FrontWeb.InfoController do
  use FrontWeb, :controller

  def info(conn, params) do
    render(conn, "hej")
  end


end
