defmodule Bff.Schemas.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
  end

  @email_regex ~r/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  @required_fields ~w(name email password)a

  def changeset(registration, attrs) do
    registration
    |> cast(attrs, @required_fields)
    |> validate_length(:name, min: 1, max: 32)
    |> validate_length(:password, min: 6, max: 32)
    |> validate_format(:email, @email_regex)
    |> validate_required(@required_fields)
  end
end
