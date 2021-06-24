# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :boilername,
  namespace: BoilerName,
  ecto_repos: [BoilerName.Repo]

# Configures the endpoint
config :boilername, UseIndieWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SECRET_FOR_DEV_GOES_HERE",
  render_errors: [view: UseIndieWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BoilerName.PubSub,
  live_view: [signing_salt: "SIGNING_SALT_GOES_HERE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
