defmodule BffWeb.SessionController do
  use BffWeb, :controller

  alias BffWeb.TokenHelpers

  def create_from_token(conn, %{"token" => token}) do
    case TokenHelpers.verify_token(token) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.page_index_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Invalid Login")
        |> redirect(to: Routes.session_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    trace_id = get_session(conn, :trace_id)
    user_id = conn.assigns.user_id

    Task.start(fn ->
      Bff.create_user_logged_out_event(user_id, trace_id, %{"id" => user_id})
    end)

    conn
    |> clear_session()
    |> put_flash(:info, gettext("Sign out successfully !"))
    |> redirect(to: Routes.page_index_path(conn, :index))
  end
end
