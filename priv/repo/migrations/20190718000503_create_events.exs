defmodule ProgramBuilder.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :foreign_key, :integer

      timestamps()
    end
  end
end
