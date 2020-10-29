defmodule Bff.Uploads do
  # Video
  def uploads_directory do
    Application.get_env(:bff, :uploads_directory)
  end

  def file_info(filename) do
    size = File.lstat!(filename).size

    file_mime = filename
    |> FileInfo.get_info()
    |> Map.get(filename)

    content_type = "#{file_mime.type}/#{file_mime.subtype}"

    %{
      "size" => size,
      "content_type" => content_type
    }
  end

  def get_path(id) do
    path = "#{uploads_directory()}/videos/#{id}/"
    if not File.exists?(path), do: File.mkdir_p!(path)
    path
  end
end
