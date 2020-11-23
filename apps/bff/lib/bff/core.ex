defmodule Bff.Core do
  alias __MODULE__.{Commands, Queries}

  # COMMANDS

  defdelegate register_user_command(data, metadata), to: Commands

  defdelegate publish_video_command(data, metadata), to: Commands

  defdelegate view_video_command(data, metadata), to: Commands

  defdelegate like_video_command(data, metadata), to: Commands

  defdelegate unlike_video_command(data, metadata), to: Commands

  # EVENTS

  defdelegate create_user_logged_event(data, metadata), to: Commands

  defdelegate create_user_logged_out_event(data, metadata), to: Commands

  defdelegate create_user_login_failed_event(data, metadata), to: Commands

  # QUERIES

  defdelegate list_events(criteria \\ []), to: Queries

  defdelegate list_videos(criteria \\ []), to: Queries
end
