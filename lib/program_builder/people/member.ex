defmodule ProgramBuilder.People.Member do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  schema "members" do
    belongs_to :unit, ProgramBuilder.Auth.Unit

    field :name, :string
    has_one :spouse, Member

    field :moved_in, :date
    field :moved_out, :date

    field :speak, :boolean, default: true
    field :pray, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:name, :moved_in, :moved_out, :speak, :pray])
    |> cast_assoc(:spouse, with: &Member.changeset/2)
    |> validate_required([:name, :moved_in, :moved_out])
  end
end
