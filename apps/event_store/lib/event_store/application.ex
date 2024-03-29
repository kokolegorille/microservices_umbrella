defmodule EventStore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      {EventStore.Repo, []},

      # Start the Telemetry supervisor
      EventStore.Telemetry,

      # Start the listeners provider
      EventStore.Core.ListenersProvider
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
