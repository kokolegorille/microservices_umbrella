defmodule ApiGW do
  @moduledoc """
  ApiGW keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # EVENTS

  defdelegate list_events(criteria \\ []), to: EventStore

  # VIDEOS

  defdelegate list_videos(criteria \\ []), to: VideoStore

  defdelegate get_video(id), to: VideoStore
end
