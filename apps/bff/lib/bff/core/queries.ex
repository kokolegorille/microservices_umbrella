defmodule Bff.Core.Queries do
  defdelegate list_events(criteria \\ []), to: EventStore

  defdelegate list_videos(criteria \\ []), to: VideoStore
end
