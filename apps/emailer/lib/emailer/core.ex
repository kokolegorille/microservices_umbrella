defmodule Emailer.Core do
  #########################
  # EVENT STORE
  #########################

  def create_event(event_or_command) do
    EventStore.create_event(event_or_command)
  end
end
