defmodule ApiGWWeb.EventController do
  use ApiGWWeb, :controller

  def index(conn, _params) do
    events = ApiGW.list_events(order: :desc)
    render(conn, "index.json", events: events)
  end
end
