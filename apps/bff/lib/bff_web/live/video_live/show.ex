defmodule BffWeb.VideoLive.Show do
  use BffWeb, :live_view

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = session, socket) do
    {:ok,
    socket
      |> assign(trace_id: trace_id)
      |> assign(user_id: session["user_id"])
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user_id = socket.assigns.user_id
    trace_id = socket.assigns.trace_id

    Bff.view_video_command(
      user_id,
      trace_id,
      %{
        "user_id" => user_id,
        "video_id" => id
      }
    )

    {:noreply, assign(socket, :video, VideoStore.get_video(id))}
  end
end
