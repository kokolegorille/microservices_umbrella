defmodule VideoStore.Core.Aggregator do
  alias VideoStore.Core

  def replay do
    Enum.each(load_video_publishing_events(), fn event ->
      Core.create_video(event.data)
    end)
  end

  # To replay a list of events.
  def load_video_publishing_events do
    filter = [stream_name: "videoPublishing-", type: "VideoPublished"]
    EventStore.list_events(order: :asc, filter: filter)
  end
end
