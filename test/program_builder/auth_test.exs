defmodule ProgramBuilder.AuthTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Auth

  describe "units" do
    alias ProgramBuilder.Auth.Unit

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def unit_fixture(attrs \\ %{}) do
      {:ok, unit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_unit()

      unit
    end

    test "list_units/0 returns all units" do
      unit = unit_fixture()
      assert Auth.list_units() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Auth.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      assert {:ok, %Unit{} = unit} = Auth.create_unit(@valid_attrs)
      assert unit.name == "some name"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{} = unit} = Auth.update_unit(unit, @update_attrs)
      assert unit.name == "some updated name"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_unit(unit, @invalid_attrs)
      assert unit == Auth.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Auth.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Auth.change_unit(unit)
    end
  end

  describe "users" do
    @describetag :skip
    alias ProgramBuilder.Auth.User

    @valid_attrs %{email: "some email", password: "some password", username: "some username"}
    @update_attrs %{email: "some updated email", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user (password automatically hashed)" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password != "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.password != "some updated password"
      assert Argon2.verify_pass("some updated password", user.password)
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "authenticate user" do
    test "correct password" do
      user = user_fixture(%{password: "some random password"})
      id = user.id
      assert {:ok, %{id: id}} = Auth.authenticate_user(user.username, "some random password")
      assert {:error, :invalid_credentials} = Auth.authenticate_user(user.username, "wrong")
    end    
  end
end
