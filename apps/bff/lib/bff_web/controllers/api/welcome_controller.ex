defmodule BffWeb.Api.WelcomeController do
  use BffWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
