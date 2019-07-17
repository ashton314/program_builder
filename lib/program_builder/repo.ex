defmodule ProgramBuilder.Repo do
  use Ecto.Repo,
    otp_app: :program_builder,
    adapter: Ecto.Adapters.Postgres
end
