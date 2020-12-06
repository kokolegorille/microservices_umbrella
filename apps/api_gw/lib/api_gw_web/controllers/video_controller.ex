defmodule ApiGWWeb.VideoController do
  use ApiGWWeb, :controller

  alias ApiGWWeb.Plugs.EnsureAuthenticated

  action_fallback ApiGWWeb.FallbackController

  plug EnsureAuthenticated

  def index(conn, _params) do
    videos = ApiGW.list_videos(order: :desc)
    render(conn, "index.json", videos: videos)
  end

  def show(conn, %{"id" => id}) do
    video = ApiGW.get_video(id)
    render(conn, "show.json", video: video)
  end
end
