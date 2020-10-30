defmodule VideoStore.Core.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: ~w(id owner_id filename path content_type size likes_count views_count)a}
  @timestamps_opts type: :utc_datetime
  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "videos" do
    field(:owner_id, :string)
    field(:filename, :string)
    field(:path, :string)
    field(:content_type, :string)
    field(:size, :integer)
    field(:likes_count, :integer, default: 0)
    field(:views_count, :integer, default: 0)

    timestamps()
  end

  @required_fields ~w(id owner_id filename path content_type size)a

  @doc false
  def changeset(%__MODULE__{} = video, attrs \\ %{}) do
    video
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end
