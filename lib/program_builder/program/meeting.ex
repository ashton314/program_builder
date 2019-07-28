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
      :event_ids
    ])
    |> validate_required([:date])
  end
end
