defmodule Identity.Core.EventHandlers do
  require Logger

  alias Identity.Core

  def handle(%{type: "RegisterUser", data: data, metadata: metadata} = _command) do
    %{"id" => user_id} = data
    %{"trace_id" => trace_id} = metadata

    case Core.create_user(data) do
      {:ok, user} ->
        stream_name = "identity-#{user.id}"
        email_id = Ecto.UUID.generate()

        [
          %{
            "stream_name" => stream_name,
            "type" => "UserRegistered",
            "data" => to_dto(user),
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          },
          %{
            "stream_name" => "emailer:command-#{email_id}",
            "type" => "SendEmail",
            "data" => %{
              "email_id" => email_id,
              "email" => user.email,
              "name" => user.name,
            },
            "metadata" => %{
              "origin_stream_name" => stream_name,
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
        ]


      {:error, changeset} ->
        [
          %{
            "stream_name" => "identity-#{data["id"]}",
            "type" => "UserRegisterFailed",
            "data" => sanitize_errors(changeset),
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
        ]
    end
    |> Enum.each(&Core.create_event(&1))
  end

  def handle(%{type: "EmailSent", data: data, metadata: metadata} = _event) do
    Task.start(fn ->
      %{
        "stream_name" => "#{metadata["origin_stream_name"]}",
        "type" => "RegistrationEmailSent",
        "data" => %{
          "email_id" => data["id"],
          "user_id" => metadata["user_id"]
        },
        "metadata" => %{
          "trace_id" => metadata["trace_id"],
          "user_id" => metadata["user_id"]
        }
      }
      |> Core.create_event()
    end)
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end

  defp sanitize_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp to_dto(user) do
    user
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
