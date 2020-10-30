defmodule VideoStore.Repo do
  use Ecto.Repo,
    otp_app: :video_store,
    adapter: Ecto.Adapters.Postgres
end
