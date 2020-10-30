defmodule BffWeb.VideoController do
  use BffWeb, :controller

  def get_video(conn, %{"video_id" => id}) do
    case VideoStore.get_video(id) do
      nil ->
        conn
        |> put_flash(:error, gettext("Video not found."))
        |> halt()

      video ->
        conn
        |> put_resp_content_type(video.content_type)
        |> send_file(200, "#{video.path}/#{video.filename}")
    end
  end
end
