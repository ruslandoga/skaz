defmodule Skaz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SkazWeb.Telemetry,
      %{id: :migrate, start: {__MODULE__, :migrate, []}},
      Skaz.Repo,
      {Oban, Application.fetch_env!(:skaz, Oban)},
      {Phoenix.PubSub, name: Skaz.PubSub},
      {Finch, name: Skaz.finch()},
      SkazWeb.Endpoint,
      %{id: :webhook, start: {__MODULE__, :webhook, []}}
    ]

    :telemetry.attach(
      "oban-errors",
      [:oban, :job, :exception],
      &Skaz.ErrorReporter.handle_event/4,
      []
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skaz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SkazWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @doc false
  def migrate do
    if Skaz.migrate?() do
      Skaz.Release.migrate()
    end

    :ignore
  end

  @doc false
  def webhook do
    if Skaz.set_tg_webhook?() do
      Skaz.Release.set_bot_webhook()
    end

    :ignore
  end
end
