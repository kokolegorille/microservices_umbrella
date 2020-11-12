defmodule BffWeb.Plugs.EnsureAuthenticated do
  @moduledoc """
  The Plug ensure user is authenticated.
  """
  import Plug.Conn
  import Phoenix.Controller
  alias BffWeb.Router.Helpers, as: Routes

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    if conn.assigns[:user_id] do
      conn
    else
      conn
      |> put_session(:redirect_url, conn.request_path)
      |> redirect(to: Routes.session_path(conn, :index))
      |> halt()
    end
  end
end
