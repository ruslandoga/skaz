defmodule Skaz.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :skaz
  use SkazWeb, :verified_routes

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  def set_bot_webhook do
    url = SkazWeb.Endpoint.url() <> ~p"/api/bot/#{Skaz.tg_bot_token()}"

    case Bot.set_webhook(url) do
      {:ok, %Finch.Response{status: 200}} -> :ok
      {:ok, resp} -> raise "failed to set webhook to #{url}: #{inspect(resp)}"
      {:error, error} -> raise "failed to set webhook to #{url}: #{error}"
    end
  end
end
