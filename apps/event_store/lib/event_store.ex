defmodule EventStore do
  @moduledoc """
  Documentation for `EventStore`.
  """

  alias __MODULE__.Core

  defdelegate create_event(dto), to: Core

  defdelegate list_events(criteria \\ []), to: Core

  defdelegate get_event(id), to: Core
end
