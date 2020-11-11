defmodule BffWeb.VideoLive.Index do
  use BffWeb, :live_view
  require Logger

  # alias Bff.{Schemas, Uploads, PubSub}
  alias Bff.{Schemas, PubSub}
  alias Bff.Schemas.Video

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = session, socket) do
    if connected?(socket) do
      subscribe("trace_id:#{trace_id}")
      subscribe("videos")
    end
    videos = Bff.list_videos()
    {
      :ok,
      socket
      |> assign(trace_id: trace_id)
      |> assign(user_id: session["user_id"])
      |> assign(videos: videos)
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
    # No need to wait for answer

    Task.start(fn ->
      id = Ecto.UUID.generate()

      # https://github.com/phoenixframework/phoenix_live_view/issues/104
      # As of now file upload is not supported yet in liveview.
      # For fix use bas64.
      # Params contains upload_base64 attribute

      # Remove b64 header
      # data:video/mp4;base64,
      bin = params["upload_base64"]
      |> String.split(",", parts: 2)
      |> List.last()
      |> Base.decode64!()

      filename = params["upload_base64_filename"]
      user_id = socket.assigns.user_id

      video_params = FileStore.store(user_id, id, filename, bin)

      metadata = %{
        "user_id" => user_id,
        "trace_id" => socket.assigns.trace_id
      }
      Bff.publish_video_command(
        video_params,
        metadata
      )
    end)

    {
      :noreply,
      socket
      |> assign(pending: true)
      |> assign(changeset: Schemas.change_video(%Video{}))
    }
  end

  @impl true
  def handle_info(%{type: "VideoStorePublished", payload: payload}, socket) do
    socket = socket
    |> assign(pending: false)
    |> assign(videos: [payload | socket.assigns.videos])
    |> put_flash(:info, "Video Published")

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{type: "VideoStorePublishFailed", payload: _payload}, socket) do
    socket = socket
    |> assign(pending: false)
    |> put_flash(:error, "Video Published Error")

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
