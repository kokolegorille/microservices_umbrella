import Config

# Bff

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bff, BffWeb.Endpoint,
  http: [port: 4002],
  server: false

# Api GW

config :api_gw, ApiGWWeb.Endpoint,
http: [port: 4003],
server: false

# Print only warnings and errors during test
config :logger, level: :warn

# EVENT STORE
config :event_store, EventStore.Repo,
  database: "event_store_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# IDENTITY
config :identity, Identity.Repo,
  database: "identity_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Emailer
config :emailer, Emailer.Mailer, adapter: Bamboo.TestAdapter

# Video
config :bff, uploads_directory: "/home/sqrt/DATA_2020/uploads_bff"
