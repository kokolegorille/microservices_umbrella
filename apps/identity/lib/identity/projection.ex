defmodule Identity.Projection do
  alias __MODULE__.User

  # To replay a list of commands.
  # events = Identity.Projection.load_identity_commands()
  # Enum.map(events, &Identity.Core.EventHandlers.handle(&1))
  def load_identity_commands() do
    filter = [stream_name: "identity:command-"]
    EventStore.list_events(order: :asc, filter: filter)
  end

  # Identity projection.
  # Read related events, and replay inside a projection struct
  def load_identity(id) do
    filter = [stream_name: "identity-#{id}"]
    events = EventStore.list_events(order: :asc, filter: filter)

    Enum.reduce(events, %User{}, fn
      %{type: "UserRegistered", data: data} = _event, acc ->
        Enum.reduce(data, acc, fn
          {key, value}, user when key in ~w(id name email) ->
            Map.put(user, String.to_atom(key), value)
          _, user ->
            user
        end)
        |> Map.put(:is_registered, true)
      _, acc ->
        acc
    end)
  end

  def ensure_not_registered(user) do
    !user.is_registered
  end
end
