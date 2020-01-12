defmodule ProgramBuilder.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false
  alias ProgramBuilder.Repo
  alias ProgramBuilder.Auth
  alias ProgramBuilder.Auth.User

  alias ProgramBuilder.People.Member

  @doc """
  All members matching the given unit_id.
  """
  @spec list_members(unit_id :: integer()) :: [Member]
  def list_members(unit_id) do
    q = from m in Member,
      where: m.unit_id == ^unit_id
    Repo.all(q)
  end

  @doc """
  Returns the list of all members. This is not intended for normal user use. 

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_all_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  def get_member(id), do: Repo.get(Member, id)

  @doc """
  Creates a member. Don't use this. It doesn't do auth.
  """
  def create_member!(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a member if the user has permissions to do so
  """
  def create_member(attrs, %User{} = user) do
    user = Repo.preload(user, [:unit])
    if Auth.Permissions.can_create?(user, user.unit) do
      %Member{}
      |> Member.changeset(attrs)
      |> Member.changeset(%{unit_id: user.unit_id})
      |> Repo.insert()
    else
      {:error, :permission_denied}
    end
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Member. Don't use.
  """
  def delete_member!(%Member{} = member) do
    Repo.delete(member)
  end

  def delete_member(%Member{} = member, %User{} = user) do
    if Auth.Permissions.can_delete?(user, member) do
      Repo.delete(member)
    else
      {:error, :permission_denied}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{source: %Member{}}

  """
  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end
end
