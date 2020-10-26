defmodule Identity.Core.User do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts type: :utc_datetime
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @email_regex ~r/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  @required_fields ~w(name email)a
  @registration_fields ~w(password)a

  @doc false
  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
    |> validate_length(:name, min: 1, max: 32)
    |> validate_format(:email, @email_regex)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, message: "Name already taken")
    |> unique_constraint(:email, message: "Email already taken")
  end

  @doc false
  def registration_changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> changeset(attrs)
    |> cast(attrs, @registration_fields)
    |> validate_length(:password, min: 6, max: 32)
    |> validate_required(@registration_fields)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
