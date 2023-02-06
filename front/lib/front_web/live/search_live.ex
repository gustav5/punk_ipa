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
    <h1>Sök efter Punk Ipa ö</h1>
    <form phx-change="select-per-page">
      Show
      <select name="per-page">
        <%= options_for_select([10], @options.per_page) %>
      </select>
      <label for="per-page">per page</label>
    </form>
    <div class="wrapper">
      <table>
        <thead>
          <tr>
            <th class="item">
              Typ
            </th>
            <th>
              Alkoholhalt
            </th>
          </tr>
        </thead>
        <tbody>
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
                <tr>
                  <td class="item">
                      <%= button(store.namn, to: "/info/" <> store.namn, method: :get) %>

                  </td>
                  <td>
                    <%= store.alkoholhalt %>
                  </td>
                </tr>
                <% end %>
              </ul>
            </div>
          </div>
        </tbody>
      </table>
      <div class="footer">
        <div class="pagination">
          <%= if @options.page > 1 do %>
            <%= pagination_link(@socket,
                                "Previous",
                                @options.page - 1,
                                @options.per_page,
                                "previous") %>
          <% end %>
          <%= for i <- (@options.page - 2)..(@options.page + 2), i > 0 do %>
            <%= pagination_link(@socket,
                                  i,
                                  i,
                                  @options.per_page,
                                  (if i == @options.page, do: "active")) %>
          <% end %>
          <%= pagination_link(@socket,
                                "Next",
                                @options.page + 1,
                                @options.per_page,
                                "next") %>
        </div>
      </div>
    </div>

    """
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    paginate_options = %{page: page, per_page: 10}
    phrase = socket.assigns.phrase

    stores =
      case phrase == "" do
        true -> []
        false -> PunkIpa.get_beer(phrase, page)
      end

    socket =
      assign(socket,
        options: paginate_options,
        stores: stores
      )

    {:noreply, socket}
  end

  def handle_event("search", %{"phrase" => phrase}, socket) do
    socket =
      case phrase == "" do
        true ->
          socket

        false ->
          assign(socket,
            phrase: phrase,
            stores: PunkIpa.get_beer(phrase, 1)
          )
      end

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: socket.assigns.options.page,
            per_page: per_page
          )
      )

    {:noreply, socket}
  end

  defp pagination_link(socket, text, page, per_page, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class
    )
  end
end
