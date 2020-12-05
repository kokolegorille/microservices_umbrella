defmodule BffWeb.VideoLive.Show do
  use BffWeb, :live_view

  alias Bff.PubSub

  @impl true
  def mount(_params, %{"trace_id" => trace_id} = session, socket) do
    if connected?(socket) do
      subscribe("videos")
    end

    {:ok,
    socket
      |> assign(trace_id: trace_id)
      |> assign(user_id: session["user_id"])
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user_id = socket.assigns.user_id

    metadata = %{
      "user_id" => user_id,
      "trace_id" => socket.assigns.trace_id
    }

    Bff.view_video_command(
      %{
        "user_id" => user_id,
        "video_id" => id
      },
      metadata
    )

    {:noreply, assign(socket, :video, VideoStore.get_video(id))}
  end

  @impl true
  def handle_event("like", %{"id" => id}, socket) do
    user_id = socket.assigns.user_id

    metadata = %{
      "user_id" => user_id,
      "trace_id" => socket.assigns.trace_id
    }

    Bff.like_video_command(
      %{
        "user_id" => user_id,
        "video_id" => id
      },
      metadata
    )

    {:noreply, socket}
  end

  @impl true
  def handle_event("unlike", %{"id" => id}, socket) do
    user_id = socket.assigns.user_id

    metadata = %{
      "user_id" => user_id,
      "trace_id" => socket.assigns.trace_id
    }

    Bff.unlike_video_command(
      %{
        "user_id" => user_id,
        "video_id" => id
      },
      metadata
    )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{type: "VideoStoreUpdated", payload: payload}, socket) do
    socket = socket
    |> assign(video: payload)
    |> put_flash(:info, "Video Updated")

    {:noreply, socket}
  end

  # Private
  defp subscribe(topic),
    do: Phoenix.PubSub.subscribe(PubSub, topic)
end
