defmodule ApiGWWeb.AuthenticationController do
  use ApiGWWeb, :controller

  import ApiGWWeb.TokenHelpers, only: [sign: 1]

  alias ApiGWWeb.Plugs.EnsureAuthenticated
  alias ApiGWWeb.FallbackController

  action_fallback(FallbackController)

  plug(EnsureAuthenticated when action in [:delete])

  def create(conn, %{"name" => name, "password" => password}) do
    with {:ok, user} <- ApiGW.authenticate(name, password),
         token <- sign(user) do
      conn
      |> put_status(:created)
      # |> put_resp_cookie("refresh_token", %{user_id: user.id}, sign: true)
      |> render("show.json", token: token, user: user)
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json")
  end

  def delete(conn, _) do
    render(conn, "delete.json")
  end
end
