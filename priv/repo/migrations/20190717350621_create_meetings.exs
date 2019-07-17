defmodule ProgramBuilder.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :date, :date
      add :presiding, :string
      add :conducting, :string
      add :visiting, :string
      add :accompanist, :string
      add :chorester, :string
      add :opening_hymn, :integer
      add :sacrament_hymn, :integer
      add :closing_hymn, :integer
      add :topic, :string
      add :events, {:array, :integer}
      add :invocation, references(:members, on_delete: :nothing)
      add :benediction, references(:members, on_delete: :nothing)

      timestamps()
    end

    create index(:meetings, [:invocation])
    create index(:meetings, [:benediction])
  end
end
