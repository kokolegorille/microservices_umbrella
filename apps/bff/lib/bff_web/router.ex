defmodule BffWeb.Router do
  use BffWeb, :router

  alias BffWeb.Plugs.{
    EnsureTraceId,
    EnsureUserId,
    VerifyHeader,
    EnsureAuthenticated
  }

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # plug :put_root_layout, {BffWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug EnsureTraceId
    plug EnsureUserId
  end

  pipeline :root_layout do
    plug :put_root_layout, {BffWeb.LayoutView, :root}
  end

  # This will host the root of the api
  pipeline :api_layout do
    plug :put_root_layout, {BffWeb.LayoutView, :api}
  end

  pipeline :live_authenticated do
    plug(EnsureAuthenticated)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug(VerifyHeader, realm: "Bearer")
  end

  # SPA Root
  scope "/api", BffWeb.Api, as: :api do
    pipe_through [:browser, :api_layout]

    get "/", WelcomeController, :index
  end

  # Standard browser
  scope "/", BffWeb do
    pipe_through [:browser, :root_layout]

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

  scope "/api", BffWeb.Api, as: :api do
    pipe_through :api

    post("/registration", RegistrationController, :create)
    post("/authentication", AuthenticationController, :create)

    # Secure API
    pipe_through(:api_auth)

    patch("/authentication/refresh", AuthenticationController, :refresh)
    delete("/authentication", AuthenticationController, :delete)
  end

  # Bamboo Email Viewer
  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
