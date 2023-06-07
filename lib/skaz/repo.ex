defmodule Skaz.Repo do
  use Ecto.Repo,
    otp_app: :skaz,
    adapter: Ecto.Adapters.SQLite3
end
