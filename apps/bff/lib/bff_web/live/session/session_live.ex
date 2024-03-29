defmodule BffWeb.SessionLive do
  use BffWeb, :live_view

  alias Bff
  alias Bff.Schemas
  alias Bff.Schemas.Session
  alias BffWeb.TokenHelpers

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = _session, socket) do
    {:ok, assign(socket, trace_id: trace_id)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    changeset = Schemas.change_session(%Session{})
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event(
        "save",
        %{"session" => %{"name" => name, "password" => password} = params},
        socket
      ) do

    socket =
      case Bff.authenticate(name, password) do
        {:ok, user} ->
          metadata = %{
            "user_id" => user.id,
            "trace_id" => socket.assigns.trace_id
          }
          Task.start(fn ->
            Bff.create_user_logged_event(params, metadata)
          end)

          token = TokenHelpers.sign(user)

          socket
          |> put_flash(:info, "User Logged in")
          |> redirect(to: Routes.session_from_token_path(socket, :create_from_token, token))

        {:error, reason} ->
          case Bff.get_user_by_name(name) do
            nil ->
              nil

            user ->
              metadata = %{
                "user_id" => user.id,
                "trace_id" => socket.assigns.trace_id
              }
              Task.start(fn ->
                Bff.create_user_login_failed_event(params, metadata)
              end)
          end

          put_flash(socket, :error, "User could not log in #{inspect(reason)}")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("change", %{"session" => payload}, socket) do
    changeset = Schemas.change_session(%Session{}, payload)
    {:noreply, assign(socket, changeset: changeset)}
  end
end
