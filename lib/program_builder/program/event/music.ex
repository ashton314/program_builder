defmodule ProgramBuilder.Program.Event.Music do
  use Ecto.Schema
  import Ecto.Changeset

  schema "music" do
    field :"C-c", :string
    field :number, :integer
    field :performer, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(music, attrs) do
    music
    |> cast(attrs, [:number, :title, :performer, :"C-c", :"C-c"])
    |> validate_required([:number, :title, :performer, :"C-c", :"C-c"])
  end
end
