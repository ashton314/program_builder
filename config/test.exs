import Config

# Turn down the Argon2 hashing so our tests don't take 8+ seconds to run
config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :program_builder, ProgramBuilderWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :program_builder, ProgramBuilder.Repo,
  username: "postgres",
  password: "postgres",
  database: "program_builder_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
