defmodule MyApp.Repo.Migrations.AddMigrations do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:organizations, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :text, null: false
      add :subdomain, :citext, null: false

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create unique_index(:organizations, [:subdomain], name: "organizations_subdomain_index")
  end

  def down do
    drop_if_exists unique_index(:organizations, [:subdomain, :subdomain],
                     name: "organizations_subdomain_index"
                   )

    drop table(:organizations)
  end
end
