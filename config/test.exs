use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :boilername, BoilerName.Repo,
  username: "postgres",
  password: "postgres",
  database: "useindie_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :boilername, UseIndieWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# https://hexdocs.pm/bcrypt_elixir/Bcrypt.html
config :bcrypt_elixir, log_rounds: 4

config :boilername, UseIndieWeb.Mailer, adapter: Bamboo.TestAdapter
