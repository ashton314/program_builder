defmodule ProgramBuilder.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :email, :string
      add :unit_id, references(:units, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:unit_id])
  end
end
