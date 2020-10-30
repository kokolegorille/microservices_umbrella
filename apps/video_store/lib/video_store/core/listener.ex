defmodule VideoStore.Core.Listener do
  use GenServer
  require Logger

  alias VideoStore.Core.EventHandlers

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(@name, nil, name: @name)
  end

  def stop, do: GenServer.cast(@name, :stop)

  @impl GenServer
  def init(_) do
    Logger.debug(fn -> "#{@name} is starting}" end)
    #
    # Subscribe to videoPublishing events
    #
    filter_fun = fn event ->
      String.starts_with?(event.stream_name, "videoPublishing-")
    end

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
