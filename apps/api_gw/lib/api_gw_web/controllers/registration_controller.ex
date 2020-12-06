defmodule ApiGWWeb.RegistrationController do
  use ApiGWWeb, :controller

  # plug(:scrub_params, "user" when action in [:create])

  # def create(conn, %{"user" => params}) do
  #   # No need to wait for answer
  #   Task.start(fn ->
  #     metadata = %{
  #       "user_id" => nil,
  #       "trace_id" => conn.assigns.trace_id
  #     }
  #     Bff.register_user_command(params, metadata)
  #   end)

  #   json conn, %{}
  # end
end
