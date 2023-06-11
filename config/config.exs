# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :skaz,
  ecto_repos: [Skaz.Repo]

config :skaz, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: Skaz.Repo

# Configures the endpoint
config :skaz, SkazWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: SkazWeb.ErrorHTML, json: SkazWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Skaz.PubSub,
  live_view: [signing_salt: "/RYwAtPS"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :skaz, Skaz.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sentry,
  client: Sentry.Finch,
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()]

config :logger, Sentry.LoggerBackend,
  capture_log_messages: true,
  metadata: [:request_id],
  level: :warn

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
