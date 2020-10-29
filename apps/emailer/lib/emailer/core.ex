defmodule Emailer.Core do
  @moduledoc """
  Documentation for `Emailer Core`.
  """

  def create_event(event_or_command) do
    EventStore.create_event(event_or_command)
  end
end
