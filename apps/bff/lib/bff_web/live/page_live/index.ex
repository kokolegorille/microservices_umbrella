defmodule BffWeb.PageLive.Index do
  use BffWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
