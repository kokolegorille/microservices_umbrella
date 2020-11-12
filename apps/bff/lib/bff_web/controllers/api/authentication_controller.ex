defmodule BffWeb.Api.AuthenticationController do
  use BffWeb, :controller

  alias BffWeb.Api.FallbackController

  action_fallback(FallbackController)

end
