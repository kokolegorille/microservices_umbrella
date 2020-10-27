defmodule Bff.Core.EventHandlers do
  require Logger

  alias Bff.PubSub

  def handle(%{type: "UserRegistered" = type} = event) do
    %{data: data, metadata: %{"trace_id" => trace_id}} = event
    Phoenix.PubSub.broadcast(PubSub, "trace_id:#{trace_id}", %{type: type, payload: data})
  end

  def handle(%{type: "UserRegisterFailed" = type} = event) do
    %{data: data, metadata: %{"trace_id" => trace_id}} = event
    Phoenix.PubSub.broadcast(PubSub, "trace_id:#{trace_id}", %{type: type, payload: data})
  end

  def handle(event) do
    Logger.info("#{__MODULE__} Unknown Event #{inspect(event)}")
  end
end
