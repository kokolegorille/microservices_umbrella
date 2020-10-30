defmodule VideoStore do
  @moduledoc """
  Documentation for `VideoStore`.
  """

  alias __MODULE__.Core

  defdelegate list_videos(criteria \\ []), to: Core

  defdelegate get_video(id, opts \\ []), to: Core

  # Aggregator

  defdelegate replay(), to: Core

  defdelegate load_video_publishing_events(), to: Core
end
