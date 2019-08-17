defmodule ProgramBuilder.Program.Meeting do
  use Ecto.Schema
  alias ProgramBuilder.Program
  import Ecto.Changeset

  schema "meetings" do
    # belongs_to :unit, ProgramBuilder.Unit

    field :date, :date
    field :topic, :string

    field :presiding, :string
    field :conducting, :string
    field :visiting, :string

    field :accompanist, :string
    field :chorester, :string
    field :opening_hymn, :integer
    field :closing_hymn, :integer
    field :invocation, :id
    field :benediction, :id

    field :announcements, {:array, :string}
    field :callings, {:array, :string}
    field :releases, {:array, :string}
    field :stake_business, :string, default: ""

    has_many :events, Program.Event

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
      :closing_hymn,
      :topic,
      :announcements,
      :callings,
      :releases,
      :stake_business,
      :invocation,
      :benediction
    ])
    |> validate_required([:date])
    |> validate_number(:opening_hymn, greater_than_or_equal_to: 1, less_than_or_equal_to: 341)
    |> cast_assoc(:events, with: &Program.Event.changeset/2)
  end
end
