defmodule Emailer.Projection do
  alias __MODULE__.Email

  # Replay service commands
  def replay do
    Enum.map(load_email_commands(), &Emailer.Core.EventHandlers.handle(&1))
  end

  # Returns commands for the service
  def load_email_commands() do
    filter = [stream_name: "sendEmail:command-"]
    EventStore.list_events(order: :asc, filter: filter)
  end

  # Email projection.
  # Read related events, and replay inside a projection struct
  def load_email(id) do
    filter = [stream_name: "sendEmail-#{id}"]
    events = EventStore.list_events(order: :asc, filter: filter)

    Enum.reduce(events, %Email{}, fn
      %{type: "EmailSent", data: data} = _event, acc ->
        Enum.reduce(data, acc, fn
          {key, value}, email when key in ~w(id to subject html to) ->
            Map.put(email, String.to_atom(key), value)
          _, email ->
            email
        end)
        |> Map.put(:is_sent, true)
      _, acc ->
        acc
    end)
  end

  def ensure_email_has_not_been_sent(email) do
    !email.is_sent
  end
end
