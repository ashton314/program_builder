defmodule ProgramBuilder.PeopleTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.People

  describe "members" do
    alias ProgramBuilder.People.Member

    @valid_attrs %{moved_in: ~D[2010-04-17], moved_out: ~D[2010-04-17], name: "some name"}
    @update_attrs %{moved_in: ~D[2011-05-18], moved_out: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{moved_in: nil, moved_out: nil, name: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert People.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert People.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = People.create_member(@valid_attrs)
      assert member.moved_in == ~D[2010-04-17]
      assert member.moved_out == ~D[2010-04-17]
      assert member.name == "some name"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = People.update_member(member, @update_attrs)
      assert member.moved_in == ~D[2011-05-18]
      assert member.moved_out == ~D[2011-05-18]
      assert member.name == "some updated name"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_member(member, @invalid_attrs)
      assert member == People.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = People.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> People.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = People.change_member(member)
    end
  end
end
