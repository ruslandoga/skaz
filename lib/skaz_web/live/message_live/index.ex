defmodule SkazWeb.MessageLive.Index do
  use SkazWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <table>
      <thead class="text-left border-b dark:border-stone-600">
        <tr class="sticky top-0 bg-stone-100 dark:bg-stone-800">
          <th class="p-2 border-b dark:border-stone-600">Date</th>
          <th class="p-2 border-b dark:border-stone-600">Message</th>
          <th></th>
        </tr>
      </thead>
      <tbody id="messages" phx-update="stream" class="space-y-1">
        <%= for {id, message} <- @streams.messages do %>
          <tr id={id} class="border-t dark:border-stone-600 text-sm">
            <td class="p-2 whitespace-nowrap font-semibold"><%= message.date %></td>
            <td class="p-2 prose dark:prose-invert w-full"><%= message.content %></td>
            <td class="p-2 font-semibold flex">
              <.link
                patch={~p"/messages/#{message.id}"}
                class="m-1 px-1 py-0.5 rounded border bg-gray-100 hover:bg-gray-200 transition"
              >
                show
              </.link>
              <button class="m-1 px-1 py-0.5 rounded border bg-gray-100 hover:bg-gray-200 transition">
                todo
              </button>
              <button class="m-1 px-1 py-0.5 rounded border bg-gray-100 hover:bg-gray-200 transition">
                paper
              </button>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>

    <%= if @message do %>
      <.modal id="show-message" on_cancel={JS.patch(~p"/messages")} show={@message}>
        <div class="prose">
          <pre><%= Jason.decode!(@message.json) |> Jason.encode_to_iodata!(pretty: true) %></pre>
        </div>
      </.modal>
    <% end %>
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
    socket
    |> assign(:page_title, "messages")
    |> assign(:message, nil)
  end

  defp apply_action(socket, :show, %{"id" => rowid}) do
    if message = get_message(rowid) do
      socket
      |> assign(:page_title, "message ##{rowid}")
      |> assign(:message, message)
    else
      socket |> put_flash(:error, "message not found") |> push_patch(to: ~p"/messages")
    end
  end

  defp get_message(rowid) do
    import Ecto.Query, only: [from: 2]
    q = from(m in "tg_messages", where: m.rowid == ^rowid, select: %{json: m.json})
    Skaz.Repo.one(q)
  end

  defp list_messages do
    import Ecto.Query, only: [from: 2]

    q =
      from(m in "tg_messages",
        order_by: [desc: m.rowid],
        select: %{
          id: m.rowid,
          date: fragment("datetime(? -> 'message' -> 'date', 'unixepoch')", m.json),
          content: fragment("? -> 'message' ->> 'text'", m.json)
        }
      )

    Skaz.Repo.all(q)
    |> Enum.map(fn %{content: content} = message ->
      if content do
        case Earmark.as_html(content) do
          {:ok, html, _} -> %{message | content: {:safe, html}}
          _error -> message
        end
      else
        message
      end
    end)
  end
end
