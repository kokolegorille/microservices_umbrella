# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configures the endpoint
config :bff, BffWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fMewBMoKUX1L1qvnXauO9gNXrgjWx1us5jAwzcbm7SUjZoKqr35tQEyi/ENI8Ugq",
  render_errors: [view: BffWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bff.PubSub,
  live_view: [signing_salt: "12+W53f5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :event_store,
  ecto_repos: [EventStore.Repo]

config :event_store, EventStore.Repo, migration_primary_key: [name: :id, type: :binary_id]

config :postgrex, :json_library, Jason

# Identity

config :identity,
  ecto_repos: [Identity.Repo]

config :identity, Identity.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

import_config "#{Mix.env()}.exs"
