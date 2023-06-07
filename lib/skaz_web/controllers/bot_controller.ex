defmodule SkazWeb.BotController do
  use SkazWeb, :controller

  def webhook(conn, %{"token" => token} = params) do
    if Skaz.tg_bot_token() == token do
      Skaz.Bot.handle_message(params)
    end

    send_resp(conn, 200, [])
  end
end
