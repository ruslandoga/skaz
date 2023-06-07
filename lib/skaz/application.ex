defmodule Skaz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SkazWeb.Telemetry,
      %{id: :migrate, start: {__MODULE__, :migrate, []}},
      # Start the Ecto repository
      Skaz.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Skaz.PubSub},
      # Start Finch
      {Finch, name: Skaz.finch()},
      # Start the Endpoint (http/https)
      SkazWeb.Endpoint,
      %{id: :webhook, start: {__MODULE__, :webhook, []}}
      # Start a worker by calling: Skaz.Worker.start_link(arg)
      # {Skaz.Worker, arg}
    ]

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
    Skaz.Release.migrate()
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
