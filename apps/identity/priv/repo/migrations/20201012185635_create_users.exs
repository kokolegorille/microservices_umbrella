defmodule Identity.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :citext, null: false
      add :password_hash, :string

      timestamps(type: :utc_datetime)
    end
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])
  end
end
