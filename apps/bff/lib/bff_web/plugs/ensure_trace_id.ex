defmodule BffWeb.Plugs.EnsureTraceId do
  import Plug.Conn

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    case get_session(conn, :trace_id) do
      nil ->
        put_session(conn, :trace_id, Ecto.UUID.generate())

      _trace_id ->
        conn
    end
  end
end
