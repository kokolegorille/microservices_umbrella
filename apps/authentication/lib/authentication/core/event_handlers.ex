defmodule Authentication.Core.EventHandlers do
  require Logger

  alias Authentication.Core

  def handle(%{type: "UserRegistered", data: data} = _event) do
    Core.create_user(data)
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end
end
