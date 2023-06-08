defmodule Skaz do
  @moduledoc """
  Skaz keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @app :skaz

  def finch, do: __MODULE__.Finch

  keys = [
    :migrate?,
    :tg_bot_token,
    :set_tg_webhook?,
    :basic_auth
  ]

  for key <- keys do
    def unquote(key)(), do: Application.fetch_env!(@app, unquote(key))
  end
end
