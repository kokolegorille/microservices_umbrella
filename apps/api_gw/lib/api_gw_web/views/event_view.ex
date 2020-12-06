defmodule ApiGWWeb.EventView do
  use ApiGWWeb, :view
  alias __MODULE__

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      global_position: event.global_position,
      position: event.position,
      type: event.type,
      data: event.data,
      metadata: event.metadata,
      expected_version: event.expected_version
    }
  end
end
