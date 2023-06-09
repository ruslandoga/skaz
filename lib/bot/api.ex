defmodule Bot.API do
  @moduledoc false

  def request(method, body, timeout \\ :timer.seconds(20)) do
    url = build_url(method)
    headers = [{"content-type", "application/json"}]
    body = Jason.encode_to_iodata!(body)
    req = Finch.build(:post, url, headers, body)
    Finch.request(req, Skaz.finch(), receive_timeout: timeout)
  end

  def build_url(method) do
    IO.iodata_to_binary(["https://api.telegram.org/bot", Skaz.tg_bot_token(), "/", method])
  end
end
