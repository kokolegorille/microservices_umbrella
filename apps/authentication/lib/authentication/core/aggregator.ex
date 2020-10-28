defmodule Authentication.Core.Aggregator do
  alias Authentication.Core

  def replay do
    Enum.each(load_identity_events(), fn event ->
      Core.create_user(event.data)
    end)
  end

  # To replay a list of events.
  def load_identity_events do
    filter = [stream_name: "identity-", type: "UserRegistered"]
    EventStore.list_events(order: :asc, filter: filter)
  end
end
