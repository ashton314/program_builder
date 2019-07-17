# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :program_builder,
  ecto_repos: [ProgramBuilder.Repo]

# Configures the endpoint
config :program_builder, ProgramBuilderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sbyYSDRde5LWDLBqnfcTjjMsJUB88VMwf0MEtTp6v9wRo7CJ+ZJ6DEYr+vi7Lr5F",
  render_errors: [view: ProgramBuilderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ProgramBuilder.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
