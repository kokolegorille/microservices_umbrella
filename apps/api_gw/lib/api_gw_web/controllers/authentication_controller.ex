defmodule ApiGWWeb.AuthenticationController do
  use ApiGWWeb, :controller

  # alias ApiGWWeb.Plugs.EnsureAuthenticated

  # plug(:scrub_params, "session" when action in [:create])
  # plug(EnsureAuthenticated when action in [:refresh, :delete])

  # # Because of the microservices design, this should be async...
  # # Just send the command, and wait the answer on the trace channel

  # def create(conn, %{"session" => params}) do
  #   %{"name" => name, "password" => password} = params
  #   case Bff.authenticate(name, password) do
  #     {:ok, user} ->
  #       metadata = %{
  #         "user_id" => user.id,
  #         "trace_id" => conn.assigns.trace_id
  #       }
  #       Task.start(fn ->
  #         Bff.create_user_logged_event(params, metadata)
  #       end)
  #     {:error, _reason} ->
  #       case Bff.get_user_by_name(name) do
  #         nil ->
  #           nil

  #         user ->
  #           metadata = %{
  #             "user_id" => user.id,
  #             "trace_id" => conn.assigns.trace_id
  #           }
  #           Task.start(fn ->
  #             Bff.create_user_login_failed_event(params, metadata)
  #           end)
  #       end
  #   end
  #   json conn, %{}
  # end

  # def refresh(conn, _params) do
  #   json conn, %{}
  # end

  # def delete(conn, _params) do
  #   json conn, %{}
  # end
end
