defmodule Skaz do
  @moduledoc """
  Skaz keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @app :skaz

  def finch, do: __MODULE__.Finch

  @spec tg_bot_token :: String.t()
  def tg_bot_token, do: Application.fetch_env!(@app, :tg_bot_token)

  @spec set_tg_webhook? :: boolean
  def set_tg_webhook?, do: Application.fetch_env!(@app, :set_tg_webhook?)

  @spec basic_auth :: [username: String.t(), username: String.t()]
  def basic_auth, do: Application.fetch_env!(@app, :basic_auth)
end
