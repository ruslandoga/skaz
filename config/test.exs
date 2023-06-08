import Config

# Configure your database
config :skaz, Skaz.Repo,
  database: ":memory:",
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :skaz, SkazWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "aVuocVGmSUMSsyBRqPKF4tR1cUAfFm+Nv6fL/iAy7hbNcQ61ITpcTqJ3vDOBibgv",
  server: false

# In test we don't send emails.
config :skaz, Skaz.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
