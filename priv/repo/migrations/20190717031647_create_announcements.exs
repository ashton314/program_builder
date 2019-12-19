defmodule ProgramBuilder.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :show_until, :date
      add :body, :string
      add :unit_id, references(:units, on_delete: :nothing)

      timestamps()
    end

  end
end
