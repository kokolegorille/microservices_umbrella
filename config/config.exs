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

# Configures Bff endpoint
config :bff, BffWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fMewBMoKUX1L1qvnXauO9gNXrgjWx1us5jAwzcbm7SUjZoKqr35tQEyi/ENI8Ugq",
  render_errors: [view: BffWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bff.PubSub,
  live_view: [signing_salt: "12+W53f5"]

# Configure ApiGW endpoint
config :api_gw,
  namespace: ApiGW

config :api_gw, ApiGWWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t15A/GHGjZ4/J7kJOrNx2bWx77qiob01fopJICcDe3Rl9lHoSXXLSS5sPHSDoQO4",
  render_errors: [view: ApiGWWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ApiGW.PubSub,
  live_view: [signing_salt: "MmwTLqNz"]

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

config :identity, Identity.Repo, migration_primary_key: [name: :id, type: :binary_id]

# # Authentication

# config :authentication,
#   ecto_repos: [Authentication.Repo]

# config :authentication, Authentication.Repo, migration_primary_key: [name: :id, type: :binary_id]

# VideoStore

config :video_store,
  ecto_repos: [VideoStore.Repo]

config :video_store, VideoStore.Repo, migration_primary_key: [name: :id, type: :binary_id]

import_config "#{Mix.env()}.exs"
