defmodule ProgramBuilder.Program.Meeting do
  use Ecto.Schema
  alias ProgramBuilder.Program
  alias ProgramBuilder.Auth
  import Ecto.Changeset

  @type t :: __MODULE__

  schema "meetings" do
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

    field :announcements, {:array, :string}, default: []
    field :callings, {:array, :string}, default: []
    field :releases, {:array, :string}, default: []
    field :stake_business, :string, default: ""

    has_many :events, Program.Event, on_replace: :delete
    belongs_to(:unit, Auth.Unit)

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
      :benediction,
      :unit_id
    ])
    |> validate_required([:date])
    |> assoc_constraint(:unit)
    |> validate_number(:opening_hymn, greater_than_or_equal_to: 1, less_than_or_equal_to: 341)
    |> cast_assoc(:events, with: &Program.Event.changeset/2)
  end
end
