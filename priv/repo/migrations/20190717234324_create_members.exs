defmodule ProgramBuilder.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string
      add :moved_in, :date
      add :moved_out, :date
      add :spouse, references(:members, on_delete: :nothing)

      timestamps()
    end

    create index(:members, [:spouse])
  end
end
