defmodule VideoPublishing.Core.EventHandlers do
  require Logger

  alias VideoPublishing.{Core, Projection}

  def handle(%{type: "PublishVideo", data: data, metadata: metadata} = _command) do
    video_id = data["id"]

    Task.start(fn ->
      %{
        "stream_name" => "videoPublishing-#{video_id}",
        "type" => "VideoPublished",
        "data" => data,
        "metadata" => metadata
      }
      |> Core.create_event()
    end)
  end

  def handle(%{type: "ViewVideo", data: data, metadata: metadata} = _command) do
    %{"user_id" => user_id, "video_id" => video_id} = data
    if Projection.ensure_not_viewed(user_id, video_id) do
      %{
        "stream_name" => "videoPublishing-#{video_id}",
        "type" => "VideoViewed",
        "data" => data,
        "metadata" => metadata
      }
      |> Core.create_event()
    else
      Logger.info("Video #{video_id} already viewed")
    end
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end
end
