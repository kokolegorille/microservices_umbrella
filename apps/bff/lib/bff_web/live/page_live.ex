defmodule BffWeb.PageLive do
  use BffWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    events = EventStore.list_events(order: :asc)
    {:noreply, assign(socket, events: events)}
  end

  defp display_json(json) do
    Enum.map(json, fn {key, value} ->
      "#{key}=#{truncate value}\r\n"
    end)
  end

  defp truncate(input, length \\ 30)

  defp truncate(nil, _length) do
    "nil"
  end

  defp truncate(input, length) do
    if String.length(input) > length do
      String.slice(input, 0..length) <> "..."
    else
      input
    end
  end
end
