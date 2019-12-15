import Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :program_builder, ProgramBuilderWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_BASE")

# Configure your database
config :program_builder, ProgramBuilder.Repo,
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "program_builder_prod",
  pool_size: 15
