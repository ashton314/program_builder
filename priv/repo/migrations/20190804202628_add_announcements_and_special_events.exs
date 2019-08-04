defmodule ProgramBuilder.Repo.Migrations.AddAnnouncementsAndSpecialEvents do
  use Ecto.Migration

  def change do
    alter table(:meetings) do
      add :announcements, {:array, :string}
      add :callings, {:array, :string}
      add :releases, {:array, :string}
      add :stake_business, :string
      add :baby_blessings, {:array, :string}
      add :confirmations, {:array, :string}
      add :other_ordinances, {:array, :string}
    end
  end

  def down do
    alter table(:meetings) do
      remove :announcements, {:array, :string}
      remove :callings, {:array, :string}
      remove :releases, {:array, :string}
      remove :stake_business, :string
      remove :baby_blessings, {:array, :string}
      remove :confirmations, {:array, :string}
      remove :other_ordinances, {:array, :string}
    end
  end
end
