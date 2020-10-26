defmodule Identity.Core do
  @moduledoc """
  Documentation for `Core`.
  """

  import Ecto.Query, warn: false

  alias Identity.Repo
  alias __MODULE__.User

  @order_field :name

  #########################
  # Authentication
  #########################

  @doc """
  authenticate by name and password.
  """
  def authenticate(name, password) do
    with %User{} = user <- get_user_by_name(name),
      {:ok, _} <- check_password(user, password) do
      {:ok, user}
    else
      _ -> {:error, :unauthorized}
    end
  end

  # Private

  defp get_user_by_name(name) do
    Repo.get_by(User, name: name)
  end

  defp check_password(user, password) do
    Argon2.check_pass(user, password)
  end

  #########################
  # Commands
  #########################

  @doc """
  create user workflow.
  """
  def create_user(dto) do
    with {:ok, changeset} <- validate_user(dto),
      {:ok, user} <- persist(changeset, :insert) do

      {:ok, user}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  update user workflow.
  """
  def update_user(user, dto) do
    with {:ok, changeset} <- validate_user(user, dto),
      {:ok, user} <- persist(changeset, :update) do

      {:ok, user}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  delete user workflow.
  """
  def delete_user(user) do
    Repo.delete(user)
  end

  # Private

  defp ensure_preload(any, assoc) do
    case Ecto.assoc_loaded?(Map.get(any, assoc)) do
      true -> any
      false -> any |> Repo.preload(assoc)
    end
  end

  defp validate_user(dto) do
    validate_user(%User{}, dto)
  end

  defp validate_user(user, dto) do
    case User.registration_changeset(user, dto) do
      %{valid?: true} = changeset -> {:ok, changeset}
      %{valid?: false} = changeset -> {:error, changeset}
    end
  end

  defp persist(valid_changeset, :insert) do
    Repo.insert(valid_changeset)
  end

  defp persist(valid_changeset, :update) do
    Repo.update(valid_changeset)
  end

  #########################
  # Queries
  #########################

  @doc """
  list users.
  """
  def list_users(criteria \\ []) do
    criteria
    |> list_users_query()
    |> Repo.all()
  end

  @doc """
  get user by id.
  """
  def get_user(id, opts \\ []) do
    user = Repo.get(User, id)

    case opts[:preload] do
      nil -> user
      preload -> Repo.preload(user, preload)
    end
  end

  # Private

  defp list_users_query(criteria) do
    query = from(p in User)

    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from p in query, limit: ^limit

      {:offset, offset}, query ->
        from p in query, offset: ^offset

      {:order, order}, query ->
        from p in query, order_by: [{^order, ^@order_field}]

      {:preload, preloads}, query ->
        from p in query, preload: ^preloads

      _arg, query ->
        query
    end)
  end
end
