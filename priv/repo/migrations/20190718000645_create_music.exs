defmodule ProgramBuilder.Repo.Migrations.CreateMusic do
  use Ecto.Migration

  def change do
    create table(:music) do
      add :number, :integer
      add :title, :string
      add :performer, :text
      add :"C-c", :string
      add :"C-c", :string

      timestamps()
    end

  end
end
