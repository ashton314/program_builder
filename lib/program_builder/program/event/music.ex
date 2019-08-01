defmodule ProgramBuilder.Program.Event.Music do
  use Ecto.Schema
  import Ecto.Changeset

  schema "music" do
    field :note, :string
    field :number, :integer
    field :performer, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:number, :title, :performer, :note])
  end
end
