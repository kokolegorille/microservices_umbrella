defmodule BffWeb.RegisterLive do
  use BffWeb, :live_view
  require Logger

  alias Bff
  alias Bff.{Schemas, PubSub}
  alias Bff.Schemas.Registration
  alias BffWeb.TokenHelpers

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = _session, socket) do
    if connected?(socket), do: subscribe("trace_id:#{trace_id}")
    {:ok, assign(socket, trace_id: trace_id)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    changeset = Schemas.change_registration(%Registration{})

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(pending: false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"registration" => params}, socket) do
    # No need to wait for answer
    Task.start(fn ->
      metadata = %{
        "user_id" => nil,
        "trace_id" => socket.assigns.trace_id
      }
      Bff.register_user_command(params, metadata)
    end)

    {:noreply, assign(socket, pending: true)}
  end

  @impl true
  def handle_event("change", %{"registration" => payload}, socket) do
    changeset = Schemas.change_registration(%Registration{}, payload)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_info(%{type: "UserRegistered", payload: payload}, socket) do
    token = TokenHelpers.sign(payload)

    socket =
      socket
      |> put_flash(:info, "User Registered")
      |> redirect(to: Routes.session_from_token_path(socket, :create_from_token, token))

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{type: "UserRegisterFailed", payload: payload}, socket) do
    changeset =
      Enum.reduce(payload, socket.assigns.changeset, fn {key, value}, acc ->
        Ecto.Changeset.add_error(acc, key, Enum.join(value, ", "))
      end)
      |> Map.put(:action, :insert)

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(pending: false)

    {:noreply, socket}
  end

  @impl true
  def handle_info(message, socket) do
    Logger.info("Unknown message #{inspect(message)} from #{__MODULE__}")
    {:noreply, socket}
  end

  # Private
  defp subscribe(topic),
    do: Phoenix.PubSub.subscribe(PubSub, topic)
end
