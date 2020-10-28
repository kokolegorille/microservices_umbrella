defmodule Identity.Core.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: ~w(id name email password_hash)a}
  @timestamps_opts type: :utc_datetime
  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)

    timestamps()
  end

  @email_regex ~r/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  @required_fields ~w(id name email password_hash)a

  @doc false
  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
    |> validate_length(:name, min: 1, max: 32)
    |> validate_format(:email, @email_regex)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, message: "Name already taken")
    |> unique_constraint(:email, message: "Email already taken")
    |> unique_constraint(:id)
  end

  @doc false
  def encrypt_password(password) when is_binary(password) do
    %{password_hash: password_hash} = Argon2.add_hash(password)
    password_hash
  end
end
