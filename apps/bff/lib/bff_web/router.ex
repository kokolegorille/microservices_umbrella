defmodule BffWeb.Router do
  use BffWeb, :router

  alias BffWeb.Plugs.{
    EnsureTraceId,
    EnsureUserId
  }

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BffWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EnsureTraceId
    plug EnsureUserId
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BffWeb do
    pipe_through :browser

    # get("/sessions/:token", SessionController, :create_from_token)

    resources("/sessions", SessionController, only: [:delete], singleton: true) do
      get("/:token", SessionController, :create_from_token, as: :from_token)
    end

    live "/", PageLive, :index

    live "/session", SessionLive, :index

    live "/register", RegisterLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BffWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BffWeb.Telemetry
    end
  end
end
