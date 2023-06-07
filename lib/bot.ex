defmodule Bot do
  @moduledoc "Basic telegram bot"
  alias Bot.API

  # https://core.telegram.org/bots/api#sendmessage
  def send_message(chat_id, text, opts \\ []) do
    payload = Enum.into(opts, %{"chat_id" => chat_id, "text" => text})
    API.request("sendMessage", payload)
  end
end
