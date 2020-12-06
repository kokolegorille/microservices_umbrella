defmodule BffWeb.Router do
  use BffWeb, :router

  alias BffWeb.Plugs.{
    EnsureTraceId,
    EnsureUserId,
    EnsureAuthenticated
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

  pipeline :live_authenticated do
    plug(EnsureAuthenticated)
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # Standard browser
  scope "/", BffWeb do
    pipe_through :browser

    live "/", PageLive.Index, :index

    live "/login", SessionLive, :index

    live "/register", RegisterLive, :index

    resources("/sessions", SessionController, only: [:delete], singleton: true) do
      get("/:token", SessionController, :create_from_token, as: :from_token)
    end

    resources("/videos", VideoController, only: []) do
      get "/get_video", VideoController, :get_video
    end

    pipe_through :live_authenticated

    live "/videos", VideoLive.Index, :index
    live "/videos/:id", VideoLive.Show, :show

    live "/events", EventLive.Index, :index

    # Enables LiveDashboard only for development
    #
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    if Mix.env() in [:dev, :test] do
      import Phoenix.LiveDashboard.Router

      live_dashboard "/dashboard", metrics: BffWeb.Telemetry
    end
  end

  # Bamboo Email Viewer
  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
