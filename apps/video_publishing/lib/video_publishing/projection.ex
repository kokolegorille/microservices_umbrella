defmodule VideoPublishing.Projection do
  def ensure_not_viewed(user_id, video_id) do
    user_id
      |> load_video_viewed_events(video_id)
      |> Enum.empty?()
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
