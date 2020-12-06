defmodule ApiGWWeb.Plugs.EnsureAuthenticated do
  @moduledoc false

  import Plug.Conn
  import ApiGWWeb.TokenHelpers

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    token = conn.assigns[:token]

    case verify_token(token) do
      {:ok, user} ->
        conn |> assign(:user, user)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "Unauthorized"}))
        |> halt()
    end
  end
end
