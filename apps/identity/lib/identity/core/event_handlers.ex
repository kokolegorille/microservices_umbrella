defmodule Identity.Core.EventHandlers do
  require Logger

  alias Identity.{Core, Projection}

  # This is a uniqueness validator dependency
  # to the view data authentication
  defp ensure_uniqueness(field, value) do
    Authentication.ensure_uniqueness(field, value)
  end

  def handle(%{type: "Register", data: data, metadata: metadata} = _command) do
    %{"id" => user_id} = data
    %{"trace_id" => trace_id} = metadata

    name = data["name"]
    email = data["email"]
    user = Projection.load_identity(user_id)

    with {:a, true} <- {:a, Projection.ensure_not_registered(user)},
      {:b, true} <- {:b, ensure_uniqueness(:name, name)},
      {:c, true} <- {:c, ensure_uniqueness(:email, email)} do

        Task.start(fn ->
          stream_name = "identity-#{user_id}"

          %{
            "stream_name" => stream_name,
            "type" => "UserRegistered",
            "data" => data,
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
              "html" => "Welcome <strong>#{user.name} !</strong>"
            },
            "metadata" => %{
              "origin_stream_name" => stream_name,
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
          |> Core.create_event()
        end)

    else
      {atom, _} when atom in ~w(a b)a ->
        Task.start(fn ->
          %{
            "stream_name" => "identity-#{data["id"]}",
            "type" => "UserRegisterFailed",
            "data" => %{name: ["Name already taken"]},
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
          |> Core.create_event()
        end)
      _ ->
        Task.start(fn ->
          %{
            "stream_name" => "identity-#{data["id"]}",
            "type" => "UserRegisterFailed",
            "data" => %{email: ["Email already taken"]},
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
end
