defmodule Skaz.Repo.Migrations.AddTgMessages do
  use Ecto.Migration

  def change do
    create table(:tg_messages, primary_key: false, options: "STRICT") do
      add :json, :text, null: false
    end
  end
end
