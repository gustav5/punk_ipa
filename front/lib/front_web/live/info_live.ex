defmodule FrontWeb.InfoLive do
  use FrontWeb, :live_view

  def mount(%{"brand" => brand}, session, socket) do
    data = PunkIpa.more_info(brand)


    socket =
      assign(socket,
      name: brand,
      description: data.description,
      food_pairing: data.food_pairing
      )
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="info">
      <div class="name">
        namn: <%= assigns.name %>
      </div>
      <p></p>
      <div class="description">
        beskriving: <%= assigns.description%>
      </div>
      <p></p>
      <div class="food_pairing">
        passande mat: <%= assigns.food_pairing %>
      </div>
    </div>
    """
  end

end
