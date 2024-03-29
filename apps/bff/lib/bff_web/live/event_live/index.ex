defmodule BffWeb.EventLive.Index do
  use BffWeb, :live_view
  require Logger

  alias Bff.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe("events")
    events = Bff.list_events(order: :desc, limit: 100)
    {:ok, assign(socket, events: events), temporary_assigns: [events: []]}
  end

  @impl true
  def handle_info(message, socket) do
    socket = assign(socket, events: [message])
    {:noreply, socket}
  end

  # Private
  defp subscribe(topic),
    do: Phoenix.PubSub.subscribe(PubSub, topic)

  defp display_json(json) when is_struct(json) do
    json
    |> Map.from_struct()
    |> display_json()
  end

  defp display_json(json) when is_map(json) do
    Enum.map(json, fn
      {key, value} when is_binary(value) -> "#{key}=#{truncate(value)}\r\n"
      {key, value} when is_list(value) -> "#{key}=#{truncate(Enum.join(value, ", "))}\r\n"
      {key, value} when not is_nil(value) -> "#{key}=#{inspect value}\r\n"
      {key, nil} -> "#{key}=nil"
      {key, any} -> "#{key}=unknown #{inspect any}"
    end)
  end

  defp truncate(input, length \\ 40)

  defp truncate(input, length) when is_binary(input) do
    if String.length(input) > length do
      String.slice(input, 0..length) <> "..."
    else
      input
    end
  end
end
