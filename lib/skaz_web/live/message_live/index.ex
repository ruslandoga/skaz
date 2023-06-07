defmodule SkazWeb.MessageLive.Index do
  use SkazWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.table id="messages" rows={@streams.messages}>
      <:col :let={{_id, message}} label="JSON"><pre><%= pretty_json(message.json) %></pre></:col>
    </.table>
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
    q = from m in "tg_messages", order_by: [desc: m.rowid], select: %{id: m.rowid, json: m.json}
    Skaz.Repo.all(q)
  end

  defp pretty_json(json) do
    json |> Jason.decode!() |> Jason.encode_to_iodata!(pretty: true)
  end
end
