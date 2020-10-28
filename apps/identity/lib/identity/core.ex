defmodule Identity.Core do
  @moduledoc """
  Documentation for `Core`.
  """

  def create_event(event) do
    EventStore.create_event(event)
  end
end
