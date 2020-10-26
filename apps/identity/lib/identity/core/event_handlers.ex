defmodule Identity.Core.EventHandlers do
  require Logger

  alias Identity.Core

  def handle(%{stream_name: stream_name, type: "Register", data: data} = command) do
    if String.starts_with?(stream_name, "identity:command") do
      %{metadata: %{"trace_id" => trace_id, "user_id" => user_id}} = command
      event = case Core.create_user(data) do
        {:ok, user} ->
          %{
            "stream_name" => "identity-#{user.id}",
            "type" => "User Registered",
            "data" => user,
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
        {:error, changeset} ->
          %{
            "stream_name" => "identity-#{data["id"]}",
            "type" => "User Register Failed",
            "data" => sanitize_errors(changeset),
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
      end
      create_event(event)
    end
  end

  def handle(command) do
    Logger.info "#{__MODULE__} Unknown Command #{inspect command}"
  end

  defp create_event(event) do
    EventStore.create_event(event)
  end

  defp sanitize_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
