defmodule ProgramBuilder.Repo.Migrations.CreateMeetings do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :unit_id, :string

      add :date, :date
      add :topic, :string

      add :presiding, :string
      add :conducting, :string
      add :visiting, :string

      add :accompanist, :string
      add :chorester, :string
      add :opening_hymn, :integer
      add :closing_hymn, :integer
      add :invocation, references(:members, on_delete: :nothing)
      add :benediction, references(:members, on_delete: :nothing)

      add :announcements, {:array, :string}, default: []
      add :callings, {:array, :string}, default: []
      add :releases, {:array, :string}, default: []
      add :stake_business, :string, default: ""

      timestamps()
    end

    create index(:meetings, [:invocation])
    create index(:meetings, [:benediction])
  end
end
