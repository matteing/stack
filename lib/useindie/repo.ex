defmodule UseIndie.Repo do
  use Ecto.Repo,
    otp_app: :useindie,
    adapter: Ecto.Adapters.Postgres
end
