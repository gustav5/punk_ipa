defmodule FrontWeb.SearchLive do
  use FrontWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
      phrase: "",
      stores: [],
      loading: false
      )
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Sök efter Punk Ipa öl</h1>
    <div id="search">

      <form phx-submit="search">
        <input type="text" name="phrase" value="<%= @phrase %>"
               placeholder="sökfras"
               autofocus autocomplete="off"
               <%= if @loading, do: "readonly" %> />

        <button type="submit">
          <img src="images/search.svg">
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for store <- @stores do %>
            <li>
              <div class="first-line">
                <div class="name">
                  namn: <%= store.namn %>
                </div>
                <div class="abv">
                  alkoholhalt: <%= store.alkoholhalt %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"phrase" => phrase}, socket) do
    socket = assign(socket,
      phrase: phrase,
      stores: PunkIpa.get_beer(phrase)
    )
    {:noreply, socket}
  end

  def stores() do
    [
      %{
        name: "Downtown Helena",
        street: "312 Montana Avenue",
        phone_number: "406-555-0100",
        city: "Helena, MT",
        zip: "59602",
        open: true,
        hours: "8am - 10pm M-F",
        abv: 5
      },
      %{
        name: "East Helena",
        street: "227 Miner's Lane",
        phone_number: "406-555-0120",
        city: "Helena, MT",
        zip: "59602",
        open: false,
        hours: "8am - 10pm M-F",
        abv: 5
      }
    ]
  end

end
