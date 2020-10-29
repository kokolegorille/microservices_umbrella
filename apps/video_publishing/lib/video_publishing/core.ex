defmodule VideoPublishing.Core do
  @moduledoc """
  Documentation for `Video Publishing Core`.
  """

  def create_event(event_or_command) do
    EventStore.create_event(event_or_command)
  end
end
