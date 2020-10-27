defmodule BffWeb.Plugs.EnsureUserId do
  import Plug.Conn

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    assign(conn, :user_id, user_id)
  end
end
