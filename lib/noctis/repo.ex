defmodule Noctis.Repo do
  use Ecto.Repo,
    otp_app: :noctis,
    adapter: Ecto.Adapters.Postgres
end
