defmodule Bff.Schemas.Session do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:password, :string)
  end

  @required_fields ~w(name password)a

  def changeset(session, attrs) do
    session
    |> cast(attrs, @required_fields)
    |> validate_length(:password, min: 6, max: 32)
    |> validate_required(@required_fields)
  end
end
