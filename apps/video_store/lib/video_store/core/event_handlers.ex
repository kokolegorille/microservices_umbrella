defmodule VideoStore.Core.EventHandlers do
  require Logger

  alias VideoStore.Core
  alias VideoStore.Core.Video

  def handle(%{type: "VideoPublished", data: data, metadata: metadata} = _event) do
    stream_name = "videoStore-#{data["id"]}"

    case Core.create_video(data) do
      {:ok, video} ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStorePublished",
          "data" => video,
          "metadata" => metadata
        }
      {:error, changeset} ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStorePublishFailed",
          "data" => sanitize_errors(changeset),
          "metadata" => metadata
        }
    end
    |> Core.create_event()
  end

  def handle(%{type: "VideoViewed", data: data, metadata: metadata} = _event) do
    video_id = data["video_id"]
    stream_name = "videoStore-#{video_id}"

    Core.increment_views(video_id)
    case Core.get_video(video_id) do
      %Video{} = video ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStoreUpdated",
          "data" => video,
          "metadata" => metadata
        }
        |> Core.create_event()
      nil ->
        Logger.info "Could not find video by id #{video_id}"
    end
  end

  def handle(%{type: "VideoLiked", data: data, metadata: metadata} = _event) do
    video_id = data["video_id"]
    stream_name = "videoStore-#{video_id}"

    Core.increment_likes(video_id)
    case Core.get_video(video_id) do
      %Video{} = video ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStoreUpdated",
          "data" => video,
          "metadata" => metadata
        }
        |> Core.create_event()
      nil ->
        Logger.info "Could not find video by id #{video_id}"
    end
  end

  def handle(%{type: "VideoUnliked", data: data, metadata: metadata} = _event) do
    video_id = data["video_id"]
    stream_name = "videoStore-#{video_id}"

    Core.decrement_likes(video_id)
    case Core.get_video(video_id) do
      %Video{} = video ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStoreUpdated",
          "data" => video,
          "metadata" => metadata
        }
        |> Core.create_event()
      nil ->
        Logger.info "Could not find video by id #{video_id}"
    end
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end

  defp sanitize_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  # defp to_dto(struct) do
  #   struct
  #   |> Jason.encode!()
  #   |> Jason.decode!()
  # end
end
