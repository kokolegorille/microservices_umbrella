defmodule Identity.Core.EventHandlers do
  require Logger

  alias Identity.{Core, Projection}

  def handle(%{type: "Register", data: data, metadata: metadata} = _command) do
    %{"id" => user_id} = data
    %{"trace_id" => trace_id} = metadata

    user_id
    |> Projection.load_identity()
    |> Projection.ensure_not_registered()
    |> if do
      case Core.create_user(data) do
        {:ok, user} ->
          Task.start(fn ->
            stream_name = "identity-#{user.id}"
            %{
              "stream_name" => stream_name,
              "type" => "UserRegistered",
              "data" => user,
              "metadata" => %{
                "trace_id" => trace_id,
                "user_id" => user_id
              }
            }
            |> Core.create_event()

            # Send Email Command
            email_id = Ecto.UUID.generate()
            %{
              "stream_name" => "sendEmail:command-#{email_id}",
              "type" => "SendEmail",
              "data" => %{
                "id" => email_id,
                "to" => user.email,
                "subject" => "Welcome",
                "text" => "Welcome #{user.name} !",
                "html" => "Welcome <strong>#{user.name} !</strong>",
              },
              "metadata" => %{
                "origin_stream_name" => stream_name,
                "trace_id" => trace_id,
                "user_id" => user_id
              }
            }
            |> Core.create_event()
          end)

        {:error, changeset} ->
          Task.start(fn ->
            %{
              "stream_name" => "identity-#{data["id"]}",
              "type" => "UserRegisterFailed",
              "data" => sanitize_errors(changeset),
              "metadata" => %{
                "trace_id" => trace_id,
                "user_id" => user_id
              }
            }
            |> Core.create_event()
          end)
      end
    else
      Task.start(fn ->
        %{
          "stream_name" => "identity-#{data["id"]}",
          "type" => "UserRegisterFailed",
          "data" => %{"name" => "Name already taken"},
          "metadata" => %{
            "trace_id" => trace_id,
            "user_id" => user_id
          }
        }
        |> Core.create_event()
      end)
    end
  end

  def handle(%{type: "EmailSent", data: data, metadata: metadata} = _event) do
    Task.start(fn ->
      %{
        "stream_name" => "#{metadata["origin_stream_name"]}",
        "type" => "RegistrationEmailSent",
        "data" => data,
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
end
