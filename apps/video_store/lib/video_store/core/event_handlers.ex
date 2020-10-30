defmodule VideoStore.Core.EventHandlers do
  require Logger

  alias VideoStore.Core

  def handle(%{type: "VideoPublished", data: data, metadata: metadata} = _event) do
    stream_name = "videoStore-#{data["id"]}"
    %{"trace_id" => trace_id, "user_id" => user_id} = metadata

    case Core.create_video(data) do
      {:ok, video} ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStorePublished",
          "data" => video,
          "metadata" => %{
            "trace_id" => trace_id,
            "user_id" => user_id
          }
        }
      {:error, changeset} ->
        %{
          "stream_name" => stream_name,
          "type" => "VideoStorePublishFailed",
          "data" => sanitize_errors(changeset),
          "metadata" => %{
            "trace_id" => trace_id,
            "user_id" => user_id
          }
        }
    end
    |> Core.create_event()
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
