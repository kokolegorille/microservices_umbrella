import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bff, BffWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :identity, Identity.Repo,
  database: "identity_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :event_store, EventStore.Repo,
  database: "event_store_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
