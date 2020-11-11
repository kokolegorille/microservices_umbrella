defmodule FileStore do
  @moduledoc """
  Documentation for `FileStore`.
  """

  def store(owner_id, id, filename, bin) do
    path = get_path(id)
    full_path = path <> filename

    File.write(full_path, bin)

    %{
      "id" => id,
      "owner_id" => owner_id,
      "filename" => filename,
      "path" => path,
      "hash" => hash_file(full_path)
    }
    |> Map.merge(file_info(full_path))
  end

  def get_path(id) do
    path = "#{uploads_directory()}/videos/#{id}/"
    if not File.exists?(path), do: File.mkdir_p!(path)
    path
  end

  # Private


  defp file_info(filename) do
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

  def hash_file(file_path) do
    hash_ref = :crypto.hash_init(:sha256)

    file_path
    |> File.stream!()
    |> Enum.reduce(hash_ref, fn chunk, prev_ref->
      new_ref = :crypto.hash_update(prev_ref, chunk)
      new_ref
    end)
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end

  defp uploads_directory do
    Application.get_env(:file_store, :storage_dir_prefix)
  end
end
