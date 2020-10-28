defmodule Bff do
  @moduledoc """
  Bff keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # EVENTS

  def create_user_logged_event(user_id, trace_id, attrs) do
    %{
      "stream_name" => "authentication-#{user_id}",
      "type" => "UserLoggedIn",
      "data" => filter_password(attrs),
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    } |> create_event()
  end

  def create_user_logged_out_event(user_id, trace_id, attrs) do
    %{
      "stream_name" => "authentication-#{user_id}",
      "type" => "UserLoggedOut",
      "data" => attrs,
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    } |> create_event()
  end

  def create_user_login_failed_event(user_id, trace_id, attrs) do
    %{
      "stream_name" => "authentication-#{user_id}",
      "type" => "UserLoginFailed",
      "data" => filter_password(attrs),
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    } |> create_event()
  end

  # COMMANDS

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
        |> EventStore.create_event()

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  # Private

  defp prepare_attrs(attrs) do
    attrs
    |> Map.put("id", Ecto.UUID.generate())
    |> Map.put("password_hash", encrypt_password(attrs["password"]))
    |> filter_password()
  end

  defp filter_password(attrs) do
    Map.update(attrs, "password", "--[FILTERED]--", fn _ -> "--[FILTERED]--" end)
  end

  defp encrypt_password(password) do
    Identity.encrypt_password(password)
  end

  defp create_event(event) do
    EventStore.create_event(event)
  end
end
