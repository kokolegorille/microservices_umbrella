defmodule BffWeb.VideoLive do
  use BffWeb, :live_view
  require Logger

  alias Bff.{Schemas, Uploads}
  alias Bff.Schemas.Video

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = session, socket) do
    {
      :ok,
      socket
      |> assign(trace_id: trace_id)
      |> assign(user_id: session["user_id"])
    }
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
    id = Ecto.UUID.generate()

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

    filename = params["upload_base64_filename"]
    path = Uploads.get_path(id)
    full_path = "#{path}#{filename}"

    user_id = socket.assigns.user_id

    File.write(full_path, bin)

    video_params = %{
      "id" => id,
      "owner_id" => user_id,
      "filename" => filename,
      "path" => path,
    }
    |> Map.merge(Uploads.file_info(full_path))

    # No need to wait for answer
    Task.start(fn ->
      Bff.publish_video_command(
        user_id,
        socket.assigns.trace_id,
        video_params
      )
    end)

    {:noreply, assign(socket, pending: true)}
  end
end
