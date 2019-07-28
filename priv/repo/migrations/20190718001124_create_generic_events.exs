defmodule ProgramBuilder.Repo.Migrations.CreateGenericEvents do
  use Ecto.Migration

  def change do
    create table(:generic_events) do
      add :title, :string
      add :subtitle, :string

      timestamps()
    end
  end
end
