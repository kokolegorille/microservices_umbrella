defmodule BffWeb.Api.RegistrationController do
  use BffWeb, :controller

  alias BffWeb.Api.FallbackController

  action_fallback(FallbackController)

end
