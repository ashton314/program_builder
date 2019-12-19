defmodule ProgramBuilder.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string

      timestamps()
    end

    create index(:units, [:id])
  end
end
