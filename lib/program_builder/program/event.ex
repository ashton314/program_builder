defmodule ProgramBuilder.Program.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProgramBuilder.Program

  @subtypes ~w(music talk generic note)

  schema "events" do
    belongs_to(:meeting, Program.Meeting)

    field :type, :string, default: "talk"
    belongs_to(:member, ProgramBuilder.People.Member)
    field :raw_name, :string
    field :hymn_number, :integer
    field :title, :string
    field :body, :string
    field :order_idx, :integer

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :raw_name, :hymn_number, :title, :body, :order_idx, :member_id, :meeting_id])
    |> assoc_constraint(:meeting)
    |> validate_required([:type])
    |> validate_inclusion(:type, @subtypes)
  end
end
