defmodule BoilerName.Repo do
  use Ecto.Repo,
    otp_app: :boilername,
    adapter: Ecto.Adapters.Postgres
end
