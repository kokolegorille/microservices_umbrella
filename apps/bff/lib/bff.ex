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
    }
    |> create_event()
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
    }
    |> create_event()
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
    }
    |> create_event()
  end

  # COMMANDS

  # def register_user_command(user_id, trace_id, attrs) do
  #   attrs = prepare_attrs(attrs)
  #   name = attrs["name"]
  #   email = attrs["email"]
  #   id = attrs["id"]

  #   # Ensure uniqueness through authentication view
  #   validation_tuple = {
  #     Authentication.ensure_name_uniqueness(name),
  #     Authentication.ensure_email_uniqueness(email)
  #   }

  #   {type, data, is_command?} =
  #     case validation_tuple do
  #       {true, true} ->
  #         {"Register", attrs, true}

  #       {true, false} ->
  #         {"UserRegisterFailed", %{email: ["Email already taken"]}, false}

  #       {false, true} ->
  #         {"UserRegisterFailed", %{name: ["Name already taken"]}, false}

  #       {false, false} ->
  #         {
  #           "UserRegisterFailed",
  #           %{email: ["Email already taken"], name: ["Name already taken"]},
  #           false
  #         }
  #     end

  #   stream_name =
  #     if is_command?,
  #       do: "identity:command-#{id}",
  #       else: "identity-#{id}"

  #   %{
  #     "stream_name" => stream_name,
  #     "type" => type,
  #     "data" => data,
  #     "metadata" => %{
  #       "trace_id" => trace_id,
  #       "user_id" => user_id
  #     }
  #   }
  #   |> EventStore.create_event()
  # end

  def register_user_command(user_id, trace_id, attrs) do
    attrs = prepare_attrs(attrs)
    id = attrs["id"]
    stream_name = "identity:command-#{id}"

    %{
      "stream_name" => stream_name,
      "type" => "Register",
      "data" => attrs,
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    }
    |> EventStore.create_event()
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
    Authentication.encrypt_password(password)
  end

  defp create_event(event) do
    EventStore.create_event(event)
  end
end
