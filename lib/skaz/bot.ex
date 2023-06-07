defmodule Skaz.Bot do
  @moduledoc """
  Telegram bot handler that saves all incoming messages to SQLite
  """

  @behaviour Bot.Poller

  @impl true
  def handle_message(message) do
    Skaz.Repo.insert_all("tg_messages", [[json: Jason.encode_to_iodata!(message)]])
    :ok
  end
end
