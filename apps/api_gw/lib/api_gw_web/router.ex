defmodule ApiGWWeb.Router do
  use ApiGWWeb, :router

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

    resources "/videos", VideoController, except: [:new, :edit]
    resources "/events", EventController, only: [:index]

    # Secure API
    pipe_through(:api_auth)

    patch("/authentication/refresh", AuthenticationController, :refresh)
    delete("/authentication", AuthenticationController, :delete)
  end
end
