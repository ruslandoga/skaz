defmodule Bot do
  @moduledoc "Basic telegram bot"
  alias Bot.API

  # https://core.telegram.org/bots/api#sendmessage
  def send_message(chat_id, text, opts \\ []) do
    payload = Enum.into(opts, %{"chat_id" => chat_id, "text" => text})
    API.request("sendMessage", payload)
  end

  # https://core.telegram.org/bots/api#setwebhook
  def set_webhook(url, opts \\ []) do
    payload = Enum.into(opts, %{"url" => url})
    API.request("setWebhook", payload)
  end
end
