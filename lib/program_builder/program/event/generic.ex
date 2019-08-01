defmodule ProgramBuilder.Program.Event.Generic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "generic_events" do
    field :subtitle, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(generic, attrs) do
    generic
    |> cast(attrs, [:title, :subtitle])
    |> validate_required([:title])
  end
end
