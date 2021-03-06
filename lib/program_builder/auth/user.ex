defmodule ProgramBuilder.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProgramBuilder.Auth

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    belongs_to(:unit, Auth.Unit)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :unit_id])
    |> assoc_constraint(:unit)
    |> validate_required([:username, :password])
    |> put_password_hash()
  end

  def put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end
  def put_password_hash(changeset), do: changeset
end
