defmodule ProgramBuilder.Program.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :accompanist, :string
    field :chorester, :string
    field :closing_hymn, :integer
    field :conducting, :string
    field :date, :date
    field :event_ids, {:array, :integer}
    field :opening_hymn, :integer
    field :presiding, :string
    field :sacrament_hymn, :integer
    field :topic, :string
    field :visiting, :string
    field :invocation, :id
    field :benediction, :id

    field :announcements, {:array, :string}
    field :callings, {:array, :string}
    field :releases, {:array, :string}
    field :stake_business, :string
    field :baby_blessings, {:array, :string}
    field :confirmations, {:array, :string}
    field :other_ordinances, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [
      :date,
      :presiding,
      :conducting,
      :visiting,
      :accompanist,
      :chorester,
      :opening_hymn,
      :sacrament_hymn,
      :closing_hymn,
      :topic,
      :event_ids,
      :announcements,
      :callings,
      :releases,
      :stake_business,
      :baby_blessings,
      :confirmations,
      :other_ordinances
    ])
    |> validate_required([:date])
  end
end
