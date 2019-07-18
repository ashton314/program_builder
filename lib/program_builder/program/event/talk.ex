defmodule ProgramBuilder.Program.Event.Talk do
  use Ecto.Schema
  import Ecto.Changeset

  schema "talks" do
    field :subtopic, :string
    field :visitor, :string
    field :member_id, :id

    timestamps()
  end

  @doc false
  def changeset(talk, attrs) do
    talk
    |> cast(attrs, [:visitor, :subtopic])
    |> validate_required([:visitor, :subtopic])
  end
end
