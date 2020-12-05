defmodule VideoStore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :owner_id, :string, null: false
      add :filename, :string, null: false
      add :path, :string, null: false
      add :content_type, :string, null: false
      add :size, :bigint, null: false
      add :hash, :string, null: false
      #
      add :likes_count, :bigint, default: 0
      add :views_count, :bigint, default: 0
      #
      add :liked_by, :map
      add :viewed_by, :map

      timestamps(type: :utc_datetime)
    end
  end
end
