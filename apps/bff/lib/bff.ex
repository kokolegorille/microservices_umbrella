defmodule Bff do
  @moduledoc """
  Bff keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def create_user_logged_event(user_id, trace_id, attrs) do
    %{
      "stream_name" => "identity-#{user_id}",
      "type" => "User Logged In",
      "data" => attrs,
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    }
    |> EventStore.Core.create_event()
  end

  def create_user_logged_out_event(user_id, trace_id, attrs) do
    %{
      "stream_name" => "identity-#{user_id}",
      "type" => "User Logged Out",
      "data" => attrs,
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    }
    |> EventStore.Core.create_event()
  end

  def register_user_command(user_id, trace_id, attrs) do
    attrs = prepare_attrs(attrs)

    case Identity.validate_user(attrs) do
      {:ok, _} ->
        %{
          "stream_name" => "identity:command-#{attrs["id"]}",
          "type" => "Register",
          "data" => attrs,
          "metadata" => %{
            "trace_id" => trace_id,
            "user_id" => user_id
          }
        }
        |> EventStore.Core.create_event()

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp prepare_attrs(attrs) do
    attrs
    |> Map.put("id", Ecto.UUID.generate())
    |> Map.put("password_hash", encrypt_password(attrs["password"]))
    |> Map.delete("password")
  end

  defp encrypt_password(password) do
    Identity.encrypt_password(password)
  end
end
