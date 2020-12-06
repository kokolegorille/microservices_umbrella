defmodule ApiGWWeb.VideoView do
  use ApiGWWeb, :view
  alias __MODULE__

  def render("index.json", %{videos: videos}) do
    %{data: render_many(videos, VideoView, "video.json")}
  end

  def render("show.json", %{video: video}) do
    %{data: render_one(video, VideoView, "video.json")}
  end

  def render("video.json", %{video: video}) do
    %{
      id: video.id,
      owner_id: video.owner_id,
      name: video.filename,
      content_type: video.content_type,
      size: video.size,
      likes: video.likes_count,
      views: video.views_count,
      #
      liked_by: video.liked_by,
      viewed_by: video.viewed_by
    }
  end
end
