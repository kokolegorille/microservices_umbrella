defmodule Authentication do
  @moduledoc """
  Documentation for `Authentication`.
  """
  alias __MODULE__.Core

  defdelegate authenticate(name, password), to: Core

  defdelegate ensure_uniqueness(field, value), to: Core

  defdelegate encrypt_password(password), to: Core

  defdelegate list_users(criteria \\ []), to: Core

  defdelegate get_user(id, opts \\ []), to: Core

  defdelegate get_user_by_name(name), to: Core

  # Aggregator

  defdelegate replay(), to: Core

  defdelegate load_identity_events(), to: Core
end
