defmodule ProgramBuilder.PeopleTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.People

  describe "members" do
    alias ProgramBuilder.People.Member

    @unit_attrs %{name: "Test Unit"}
    @valid_attrs %{moved_in: ~D[2010-04-17], moved_out: ~D[2010-04-17], name: "some name", unit_id: 0}
    @update_attrs %{
      moved_in: ~D[2011-05-18],
      moved_out: ~D[2011-05-18],
      name: "some updated name"
    }
    @invalid_attrs %{moved_in: nil, moved_out: nil, name: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_member!()

      member
    end

    def unit_fixture(attrs \\ %{}) do
      {:ok, unit} =
        attrs
        |> Enum.into(@unit_attrs)
        |> ProgramBuilder.Auth.create_unit()

      unit
    end

    def user_fixture(%ProgramBuilder.Auth.Unit{} = unit, attrs \\ %{}) do
      alias ProgramBuilder.Auth.User
      {:ok, user} =
        %User{}
        |> User.changeset(attrs)
        |> User.changeset(%{unit_id: unit.id})
        |> ProgramBuilder.Repo.insert()

      user
    end

    test "list_members/1 returns all members for a unit" do
      unit = unit_fixture()
      member = member_fixture(%{unit_id: unit.id})
      assert People.list_members(unit.id) == [member]
    end

    test "list_members/1 doesn't return any members for a non-existant unit" do
      assert People.list_members(-1) == []
    end

    test "get_member!/1 returns the member with given id" do
      unit = unit_fixture()
      member = member_fixture(%{unit_id: unit.id})
      assert People.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      unit = unit_fixture()
      assert {:ok, %Member{} = member} = People.create_member!(Map.put(@valid_attrs, :unit_id, unit.id))
      assert member.moved_in == ~D[2010-04-17]
      assert member.moved_out == ~D[2010-04-17]
      assert member.name == "some name"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_member!(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      unit = unit_fixture()
      member = member_fixture(%{unit_id: unit.id})
      assert {:ok, %Member{} = member} = People.update_member(member, @update_attrs)
      assert member.moved_in == ~D[2011-05-18]
      assert member.moved_out == ~D[2011-05-18]
      assert member.name == "some updated name"
    end

    test "update_member/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      member = member_fixture(%{unit_id: unit.id})
      assert {:error, %Ecto.Changeset{}} = People.update_member(member, @invalid_attrs)
      assert member == People.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      unit = unit_fixture()
      user = user_fixture(unit, %{username: "test", password: "test"})
      member = member_fixture(%{unit_id: unit.id})
      assert {:ok, %Member{}} = People.delete_member(member, user)
      assert_raise Ecto.NoResultsError, fn -> People.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      unit = unit_fixture()
      member = member_fixture(%{unit_id: unit.id})
      assert %Ecto.Changeset{} = People.change_member(member)
    end
  end
end
