# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :noctis,
  ecto_repos: [Noctis.Repo]

# Configures the endpoint
config :noctis, NoctisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3V3/0rbRruO/BqJ73STMttPvP4Jt867VnftRR6oZ2f/Kn2IQkYVLdNnCHF5p0iRh",
  render_errors: [view: NoctisWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Noctis.PubSub,
  live_view: [signing_salt: "PL4vMrfz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
