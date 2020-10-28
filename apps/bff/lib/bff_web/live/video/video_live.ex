defmodule BffWeb.VideoLive do
  use BffWeb, :live_view
  require Logger

  alias Bff.Schemas
  alias Bff.Schemas.Video

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
    # {:ok,
    #   socket
    #   |> assign(:uploaded_files, [])
    #   |> allow_upload(:video,
    #     accept: ~w(.mp4),
    #     max_entries: 5,
    #     max_file_size: 10_000_000
    #   )
    # }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    changeset = Schemas.change_video(%Video{})

    socket =
      socket
      |> assign(changeset: changeset)
      |> assign(pending: false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"video" => params}, socket) do
    # # No need to wait for answer
    # Task.start(fn ->
    #   Bff.register_user_command(nil, socket.assigns.trace_id, params)
    # end)

    IO.inspect(params["video"], label: "PARAMS")

    {:noreply, assign(socket, pending: true)}
  end

  @impl true
  def handle_event("change", %{"video" => payload}, socket) do
    changeset = Schemas.change_video(%Video{}, payload)
    {:noreply, assign(socket, changeset: changeset)}
  end
end
