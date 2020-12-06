defmodule ApiGWWeb.Router do
  use ApiGWWeb, :router

  alias ApiGWWeb.Plugs.VerifyHeader

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug(VerifyHeader, realm: "Bearer")
  end

  scope "/api", ApiGWWeb do
    pipe_through :api

    post("/registration", RegistrationController, :create)
    post("/authentication", AuthenticationController, :create)
    patch("/authentication/refresh", AuthenticationController, :refresh)

    # Secure API
    pipe_through(:api_auth)

    delete("/authentication", AuthenticationController, :delete)

    resources "/videos", VideoController, only: [:index, :show]
    resources "/events", EventController, only: [:index]
  end
end
