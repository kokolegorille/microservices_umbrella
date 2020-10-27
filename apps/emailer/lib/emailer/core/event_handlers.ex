defmodule Emailer.Core.EventHandlers do
  require Logger

  alias Emailer.Core

  def handle(%{type: "SendEmail", data: data, metadata: metadata} = _event) do
    Task.start(fn ->
      %{
        "stream_name" => "sendEmail-#{data["id"]}",
        "type" => "EmailSent",
        "data" => data,
        "metadata" => metadata
      }
      |> Core.create_event()
    end)
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end

  # defp create_event(event) do
  #   EventStore.create_event(event)
  # end
end
