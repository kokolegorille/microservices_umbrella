use Mix.Config

database_url =
  System.get_env("IDENTITY_DATABASE_URL") ||
    raise """
    environment variable IDENTITY_DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :identity, Identity.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("IDENTITY_POOL_SIZE") || "10")

database_url =
  System.get_env("EVENT_STORE_DATABASE_URL") ||
    raise """
    environment variable EVENT_STORE_DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :event_store, EventStore.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :logger, level: :info

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

# Bff

config :bff, BffWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :bff, BffWeb.Endpoint, server: true

# Api GW

config :api_gw, ApiGWWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4001"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :api_gw, ApiGWWeb.Endpoint, server: true

#
uploads =
  System.get_env("UPLOADS") || "/home/admin/uploads"

#
# FILE STORE
#
config :file_store,
  storage_dir_prefix: uploads
