defmodule ProgramBuilder.Program.Announcement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "announcements" do
    field :body, :string
    field :show_until, :date

    timestamps()
  end

  @doc false
  def changeset(announcement, attrs) do
    announcement
    |> cast(attrs, [:show_until, :body])
    |> validate_required([:show_until, :body])
  end
end
