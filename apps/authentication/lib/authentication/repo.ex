defmodule Authentication.Repo do
  use Ecto.Repo,
    otp_app: :authentication,
    adapter: Ecto.Adapters.Postgres
end
