defmodule Identity.Core.Listener do
  use GenServer
  require Logger

  alias Identity.Core

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(@name, nil, name: @name)
  end

  def stop, do: GenServer.cast(@name, :stop)

  @impl GenServer
  def init(_) do
    Logger.debug(fn -> "#{@name} is starting}" end)
    #
    register()
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast(:stop, _state), do: {:stop, :normal, nil}

  @impl GenServer
  def handle_info(%{stream_name: stream_name, type: "Register", data: data} = command, _state) do
    if String.starts_with?(stream_name, "identity:command") do
      %{metadata: %{"trace_id" => trace_id, "user_id" => user_id}} = command
      event = case Core.create_user(data) do
        {:ok, user} ->
          %{
            "stream_name" => "identity-#{user.id}",
            "type" => "User Registered",
            "data" => user,
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
        {:error, changeset} ->
          %{
            "stream_name" => "identity-#{data["id"]}",
            "type" => "User Register Failed",
            "data" => sanitize_errors(changeset),
            "metadata" => %{
              "trace_id" => trace_id,
              "user_id" => user_id
            }
          }
      end
      EventStore.create_event(event)
    end
    {:noreply, nil}
  end

  @impl GenServer
  def handle_info(message, _state) do
    Logger.info "RECEIVE EVENT : #{inspect message}"
    {:noreply, nil}
  end

  @impl GenServer
	def terminate(reason, _state) do
    Logger.debug(fn -> "#{@name} is stopping : #{inspect reason}" end)
    unregister()
    #
		:ok
  end

  defp register(filter_fun \\ fn _ -> true end) do
    EventStore.register(self(), filter_fun)
  end

  defp unregister do
    EventStore.unregister(self())
  end

  defp sanitize_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
