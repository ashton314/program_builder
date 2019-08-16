defmodule ProgramBuilder.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :unit_id, :string

      add :name, :string
      add :spouse, references(:members, on_delete: :nothing)

      add :moved_in, :date
      add :moved_out, :date

      add :speak, :boolean, default: true
      add :pray, :boolean, default: true

      timestamps()
    end

    create index(:members, [:spouse])
  end
end
