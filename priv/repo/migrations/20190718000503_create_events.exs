defmodule ProgramBuilder.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string, default: "talk"
      add :meeting_id, references(:meetings, on_delete: :delete_all)

      add :member_id, references(:members, on_delete: :nothing)
      add :raw_name, :string
      add :hymn_number, :integer
      add :title, :string
      add :body, :string
      add :order_idx, :integer

      timestamps()
    end
  end
end
