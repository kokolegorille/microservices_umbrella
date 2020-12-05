defmodule VideoPublishing.Projection do
  def ensure_not_viewed(user_id, video_id) do
    user_id
      |> load_video_viewed_events(video_id)
      |> Enum.empty?()
  end

  def ensure_not_liked(user_id, video_id) do
    not ensure_liked(user_id, video_id)
  end

  def ensure_liked(user_id, video_id) do
    user_id
    |> load_video_liked_events(video_id)
    |> Enum.reduce(false, fn
      %{type: "VideoLiked"}, _acc -> true
      %{type: "VideoUnliked"}, _acc -> false
    end)
  end

  # Private

  defp load_video_liked_events(user_id, video_id) do
    filter = [
      stream_name: "videoPublishing-#{video_id}",
      in_types: ["VideoLiked", "VideoUnliked"],
      metadata: [{"user_id", user_id}]
    ]
    EventStore.list_events(order: :asc, filter: filter)
  end

  defp load_video_viewed_events(user_id, video_id) do
    filter = [
      stream_name: "videoPublishing-#{video_id}",
      type: "VideoViewed",
      metadata: [{"user_id", user_id}]
    ]
    EventStore.list_events(order: :asc, filter: filter)
  end
end
