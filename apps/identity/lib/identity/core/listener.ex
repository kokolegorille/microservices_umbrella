defmodule Identity.Core.Listener do
  use GenServer
  require Logger

  alias Identity.Core.EventHandlers

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(@name, nil, name: @name)
  end

  def stop, do: GenServer.cast(@name, :stop)

  @impl GenServer
  def init(_) do
    Logger.debug(fn -> "#{@name} is starting}" end)
    #
    # Subscribe to identity commands, filtering the event by stream_name
    #
    filter_fun = &String.starts_with?(&1.stream_name, "identity:command")
    register(filter_fun)
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast(:stop, _state), do: {:stop, :normal, nil}

  @impl GenServer
  def handle_info(command, _state) do
    EventHandlers.handle(command)
    {:noreply, nil}
  end

  @impl GenServer
  def terminate(reason, _state) do
    Logger.debug(fn -> "#{@name} is stopping : #{inspect(reason)}" end)
    unregister()
    :ok
  end

  defp register(filter_fun), do: EventStore.register(self(), filter_fun)

  defp unregister, do: EventStore.unregister(self())
end
