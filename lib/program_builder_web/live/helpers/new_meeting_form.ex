defmodule ProgramBuilderWeb.Helpers.NewMeetingForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :accompanist, :string
    field :chorester, :string
    field :closing_hymn, :integer
    field :conducting, :string
    field :date, :date
    field :events, {:array, :map}
    field :opening_hymn, :integer
    field :presiding, :string
    field :sacrament_hymn, :integer
    field :topic, :string
    field :visiting, :string
    field :invocation, :id
    field :benediction, :id
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
      :topic
    ])
    |> validate_required([:date, :conducting])
  end
end
