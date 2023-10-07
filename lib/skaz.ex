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
    :tg_owner_id,
    :set_tg_webhook?,
    :basic_auth
  ]

  for key <- keys do
    def unquote(key)(), do: Application.fetch_env!(@app, unquote(key))
  end

  def process_all do
    import Ecto.Query

    Skaz.Repo.all(select("tg_messages", [m], %{id: m.rowid, json: m.json}))
    |> Enum.map(fn message ->
      {message, process(Jason.decode!(message.json))}
    end)
  end

  def process(
        %{
          "message" => %{
            "message_id" => message_id,
            "date" => date,
            "from" => %{"id" => from_id},
            "text" => text
          }
        } = message
      ) do
    ensure_owner!(from_id, message)

    # if message has urls, save as into getpocket.com
    # and schedule to reappear in 5 days
    if urls = urls(message) do
      Enum.map(urls, fn url ->
        %{
          type: :url,
          telegram_id: message_id,
          date: date,
          url: url,
          title: fetch_url_title(url)
        }
      end)
    end

    # if it has some datetime info like "in an hour" or "tomorrow" or "thursday weekly 18:00"
    # calendar?(text) ->
    #   if repeating?(text) do
    #     %{type: :calendar, telegram_id: message_id, date: date}
    #   else
    #     schedule_in = schedule_in(text)
    #   end

    %{type: :text, telegram_id: message_id, date: date, text: text}
  end

  def process(
        %{
          "edited_message" => %{
            "message_id" => message_id,
            "from" => %{"id" => from_id},
            "text" => text
          }
        } = message
      ) do
    ensure_owner!(from_id, message)
    %{type: :edit, telegram_id: message_id, text: text}
  end

  defp ensure_owner!(from_id, message) do
    unless from_id == tg_owner_id() do
      raise "invalid from_id: #{from_id} in message:\n#{inspect(message)}"
    end
  end
end
