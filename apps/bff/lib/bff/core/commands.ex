defmodule Bff.Core.Commands do

  # COMMANDS

  def register_user_command(data, metadata) do
    data = prepare_data(data)
    id = data["id"]
    stream_name = "identity:command-#{id}"

    %{
      "stream_name" => stream_name,
      "type" => "RegisterUser",
      "data" => data,
      "metadata" => metadata
    }
  end

  def publish_video_command(data, metadata) do
    id = data["id"]
    stream_name = "videoPublishing:command-#{id}"
    %{
      "stream_name" => stream_name,
      "type" => "PublishVideo",
      "data" => data,
      "metadata" => metadata
    }
  end

  def view_video_command(data, metadata) do
    id = data["video_id"]
    stream_name = "videoStore:command-#{id}"
    %{
      "stream_name" => stream_name,
      "type" => "ViewVideo",
      "data" => data,
      "metadata" => metadata
    }
  end

  # EVENTS

  def create_user_logged_event(attrs, metadata) do
    user_id = metadata["user_id"]
    %{
      "stream_name" => "identity-#{user_id}",
      "type" => "UserLoggedIn",
      "data" => filter_password(attrs),
      "metadata" => metadata
    }
  end

  def create_user_logged_out_event(attrs, metadata) do
    user_id = metadata["user_id"]
    %{
      "stream_name" => "identity-#{user_id}",
      "type" => "UserLoggedOut",
      "data" => attrs,
      "metadata" => metadata
    }
  end

  def create_user_login_failed_event(attrs, metadata) do
    user_id = metadata["user_id"]
    %{
      "stream_name" => "identity-#{user_id}",
      "type" => "UserLoginFailed",
      "data" => filter_password(attrs),
      "metadata" => metadata
    }
  end

  # Private

  defp prepare_data(data) do
    data
    |> put_id()
    |> Map.put("password_hash", encrypt_password(data["password"]))
    |> filter_password()
  end

  defp put_id(data) do
    Map.put(data, "id", Ecto.UUID.generate())
  end

  defp filter_password(data) do
    Map.update(data, "password", "--[FILTERED]--", fn _ -> "--[FILTERED]--" end)
  end

  defp encrypt_password(password) do
    Identity.encrypt_password(password)
  end
end
