defmodule Emailer.Core.EventHandlers do
  require Logger

  # alias Emailer.Core

  def handle(command) do
    Logger.info "#{__MODULE__} Unknown Command #{inspect command}"
  end

  # defp create_event(event) do
  #   EventStore.create_event(event)
  # end
end
