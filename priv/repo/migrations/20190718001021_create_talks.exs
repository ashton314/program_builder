defmodule ProgramBuilder.Repo.Migrations.CreateTalks do
  use Ecto.Migration

  def change do
    create table(:talks) do
      add :visitor, :string
      add :subtopic, :string
      add :member_id, references(:members, on_delete: :nothing)

      timestamps()
    end

    create index(:talks, [:member_id])
  end
end
