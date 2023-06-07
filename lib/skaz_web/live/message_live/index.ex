defmodule SkazWeb.MessageLive.Index do
  use SkazWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <table>
      <thead class="text-left border-b">
        <tr class="sticky top-0 bg-stone-100 dark:bg-stone-800">
          <th class="p-2 border-b">Date</th>
          <th class="p-2 border-b">Message</th>
        </tr>
      </thead>
      <tbody id="messages" phx-update="stream" class="space-y-1">
        <%= for {id, message} <- @streams.messages do %>
          <tr id={id} class="border-t text-sm">
            <td class="p-2 whitespace-nowrap font-semibold"><%= message.date %></td>
            <td class="p-2"><%= message.content %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :messages, list_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Listing Messages")
  end

  defp list_messages do
    import Ecto.Query, only: [from: 2]

    q =
      from m in "tg_messages",
        order_by: [desc: m.rowid],
        select: %{
          id: m.rowid,
          date: fragment("datetime(? -> 'message' -> 'date', 'unixepoch')", m.json),
          content: fragment("? -> 'message' ->> 'text'", m.json)
        }

    Skaz.Repo.all(q)
  end
end
