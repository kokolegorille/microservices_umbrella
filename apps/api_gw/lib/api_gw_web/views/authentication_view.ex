defmodule ApiGWWeb.AuthenticationView do
  @moduledoc false
  use ApiGWWeb, :view

  def render("show.json", %{token: token, user: user}),
    do: %{token: token, user: user_json(user)}

  def render("error.json", _),
    do: %{error: "Invalid username or password"}

  def render("delete.json", _), do: %{ok: true}

  # PRIVATE

  defp user_json(user), do: %{id: user.id, name: user.name}
end
