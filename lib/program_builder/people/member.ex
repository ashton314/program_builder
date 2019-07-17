defmodule ProgramBuilder.People.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :moved_in, :date
    field :moved_out, :date
    field :name, :string
    field :spouse, :id

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name, :moved_in, :moved_out])
    |> validate_required([:name, :moved_in, :moved_out])
  end
end
