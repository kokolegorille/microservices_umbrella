defmodule Identity do
  @moduledoc """
  Documentation for `Identity`.
  """

  alias __MODULE__.Core

  defdelegate authenticate(name, password), to: Core

  defdelegate encrypt_password(password), to: Core

  defdelegate create_user(dto), to: Core

  defdelegate update_user(user, dto), to: Core

  defdelegate delete_user(user), to: Core

  defdelegate list_users(criteria \\ []), to: Core

  defdelegate get_user(id, opts \\ []), to: Core

  defdelegate get_user_by_name(name), to: Core

  defdelegate validate_user(dto), to: Core

  defdelegate validate_user(user, dto), to: Core
end
