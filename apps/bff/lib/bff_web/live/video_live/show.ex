defmodule BffWeb.VideoLive.Show do
  use BffWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:video, VideoStore.get_video(id))}
  end
end
