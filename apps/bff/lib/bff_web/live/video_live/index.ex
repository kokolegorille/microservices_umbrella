defmodule BffWeb.VideoLive.Index do
  use BffWeb, :live_view
  require Logger

  alias Bff.PubSub

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

  # @impl true
  # def handle_params(_params, _url, socket) do
  #   {:noreply, socket}
  # end

  @impl true
  def handle_info(%{type: "VideoStorePublished", payload: payload}, socket) do
    socket = socket
    |> assign(videos: [payload | socket.assigns.videos])
    |> put_flash(:info, "Video Published")

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{type: "VideoStorePublishFailed", payload: _payload}, socket) do
    {:noreply, put_flash(socket, :error, "Video Published Error")}
  end

  @impl true
  def handle_info(%{type: "VideoStoreUpdated", payload: payload}, socket) do
    videos = socket.assigns.videos
    |> Enum.map(fn
      %{id: id} when id == payload.id -> payload
      video -> video
    end)

    socket = socket
    |> assign(videos: videos)
    |> put_flash(:info, "Video Updated")

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
