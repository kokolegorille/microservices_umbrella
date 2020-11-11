defmodule Bff do
  @moduledoc """
  Bff keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias __MODULE__.Core

  # QUERIES

  defdelegate list_events(criteria \\ []), to: Core

  defdelegate list_videos(criteria \\ []), to: Core

  # COMMANDS

  def register_user_command(data, metadata) do
    data
    |> Core.register_user_command(metadata)
    |> create_event()
  end

  def view_video_command(data, metadata) do
    data
    |> Core.view_video_command(metadata)
    |> create_event()
  end

  def publish_video_command(data, metadata) do
    data
    |> Core.publish_video_command(metadata)
    |> create_event()
  end

  # EVENTS

  def create_user_logged_event(data, metadata) do
    data
    |> Core.create_user_logged_event(metadata)
    |> create_event()
  end

  def create_user_logged_out_event(data, metadata) do
    data
    |> Core.create_user_logged_out_event(metadata)
    |> create_event()
  end

  def create_user_login_failed_event(data, metadata) do
    data
    |> Core.create_user_login_failed_event(metadata)
    |> create_event()
  end

  defdelegate create_event(event), to: EventStore
end
