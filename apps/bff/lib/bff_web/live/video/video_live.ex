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

    IO.inspect(params, label: "PARAMS")

    # https://github.com/phoenixframework/phoenix_live_view/issues/104
    # As of now file upload is not supported yet in liveview.
    # For fix use bas64.
    # Params contains upload_base64 attribute

    # Remove b64 header
    # data:video/mp4;base64,

    base64 = params["upload_base64"]
    |> String.split(",", parts: 2)
    |> List.last()

    bin = Base.decode64!(base64)

    file_path = "/tmp/file.mp4"

    File.write(file_path, bin)

    {:noreply, assign(socket, pending: true)}
  end
end
