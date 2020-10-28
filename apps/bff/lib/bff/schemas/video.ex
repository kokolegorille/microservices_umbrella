defmodule Bff.Schemas.Video do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:video, :string)
  end

  @required_fields ~w(video)a

  def changeset(video, attrs) do
    video
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
