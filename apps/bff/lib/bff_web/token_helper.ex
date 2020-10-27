defmodule BffWeb.TokenHelpers do
  @moduledoc """
  Hold logic for signing and checking phoenix token
  """

  alias BffWeb.Endpoint

  @salt "user salt"
  # one minute
  @max_age 60

  # This is used in authentication plug and user_socket
  # Don't store user directly, as it will exposes sensitive fields
  def sign(user), do: Phoenix.Token.sign(Endpoint, @salt, %{id: user.id, name: user.name})

  def verify_token(token), do: Phoenix.Token.verify(Endpoint, @salt, token, max_age: @max_age)
end
