defmodule Bff.Core.EventHandlers do
  require Logger

  alias Bff.PubSub

  def handle(%{type: "UserRegistered" = type} = event) do
    %{data: data, metadata: %{"trace_id" => trace_id}} = event
    Phoenix.PubSub.broadcast(PubSub, "trace_id:#{trace_id}", %{type: type, payload: data})
    Phoenix.PubSub.broadcast(PubSub, "events", event)
  end

  def handle(%{type: "UserRegisterFailed" = type} = event) do
    %{data: data, metadata: %{"trace_id" => trace_id}} = event
    Phoenix.PubSub.broadcast(PubSub, "trace_id:#{trace_id}", %{type: type, payload: data})
    Phoenix.PubSub.broadcast(PubSub, "events", event)
  end

  def handle(%{type: "VideoStorePublished" = type} = event) do
    %{data: data} = event
    Phoenix.PubSub.broadcast(PubSub, "videos", %{type: type, payload: data})

    Phoenix.PubSub.broadcast(PubSub, "events", event)
  end

  def handle(%{type: "VideoStoreUpdated" = type} = event) do
    %{data: data} = event
    Phoenix.PubSub.broadcast(PubSub, "videos", %{type: type, payload: data})
  end

  def handle(event) do
    Phoenix.PubSub.broadcast(PubSub, "events", event)
  end
end
