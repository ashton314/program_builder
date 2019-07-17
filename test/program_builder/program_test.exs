defmodule ProgramBuilder.ProgramTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Program

  describe "meetings" do
    alias ProgramBuilder.Program.Meeting

    @valid_attrs %{
      accompanist: "some accompanist",
      chorester: "some chorester",
      closing_hymn: 42,
      conducting: "some conducting",
      date: ~D[2010-04-17],
      opening_hymn: 42,
      presiding: "some presiding",
      sacrament_hymn: 42,
      visiting: "some visiting"
    }
    @update_attrs %{
      accompanist: "some updated accompanist",
      chorester: "some updated chorester",
      closing_hymn: 43,
      conducting: "some updated conducting",
      date: ~D[2011-05-18],
      opening_hymn: 43,
      presiding: "some updated presiding",
      sacrament_hymn: 43,
      visiting: "some updated visiting"
    }
    @invalid_attrs %{
      accompanist: nil,
      chorester: nil,
      closing_hymn: nil,
      conducting: nil,
      date: nil,
      opening_hymn: nil,
      presiding: nil,
      sacrament_hymn: nil,
      visiting: nil
    }

    def meeting_fixture(attrs \\ %{}) do
      {:ok, meeting} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Program.create_meeting()

      meeting
    end

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert Program.list_meetings() == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert Program.get_meeting!(meeting.id) == meeting
    end

    test "create_meeting/1 with valid data creates a meeting" do
      assert {:ok, %Meeting{} = meeting} = Program.create_meeting(@valid_attrs)
      assert meeting.accompanist == "some accompanist"
      assert meeting.chorester == "some chorester"
      assert meeting.closing_hymn == 42
      assert meeting.conducting == "some conducting"
      assert meeting.date == ~D[2010-04-17]
      assert meeting.opening_hymn == 42
      assert meeting.presiding == "some presiding"
      assert meeting.sacrament_hymn == 42
      assert meeting.visiting == "some visiting"
    end

    test "create_meeting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Program.create_meeting(@invalid_attrs)
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{} = meeting} = Program.update_meeting(meeting, @update_attrs)
      assert meeting.accompanist == "some updated accompanist"
      assert meeting.chorester == "some updated chorester"
      assert meeting.closing_hymn == 43
      assert meeting.conducting == "some updated conducting"
      assert meeting.date == ~D[2011-05-18]
      assert meeting.opening_hymn == 43
      assert meeting.presiding == "some updated presiding"
      assert meeting.sacrament_hymn == 43
      assert meeting.visiting == "some updated visiting"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_meeting(meeting, @invalid_attrs)
      assert meeting == Program.get_meeting!(meeting.id)
    end

    test "delete_meeting/1 deletes the meeting" do
      meeting = meeting_fixture()
      assert {:ok, %Meeting{}} = Program.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Program.get_meeting!(meeting.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = Program.change_meeting(meeting)
    end
  end

  describe "announcements" do
    alias ProgramBuilder.Program.Announcement

    @valid_attrs %{body: "some body", show_until: ~D[2010-04-17]}
    @update_attrs %{body: "some updated body", show_until: ~D[2011-05-18]}
    @invalid_attrs %{body: nil, show_until: nil}

    def announcement_fixture(attrs \\ %{}) do
      {:ok, announcement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Program.create_announcement()

      announcement
    end

    test "list_announcements/0 returns all announcements" do
      announcement = announcement_fixture()
      assert Program.list_announcements() == [announcement]
    end

    test "get_announcement!/1 returns the announcement with given id" do
      announcement = announcement_fixture()
      assert Program.get_announcement!(announcement.id) == announcement
    end

    test "create_announcement/1 with valid data creates a announcement" do
      assert {:ok, %Announcement{} = announcement} = Program.create_announcement(@valid_attrs)
      assert announcement.body == "some body"
      assert announcement.show_until == ~D[2010-04-17]
    end

    test "create_announcement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Program.create_announcement(@invalid_attrs)
    end

    test "update_announcement/2 with valid data updates the announcement" do
      announcement = announcement_fixture()

      assert {:ok, %Announcement{} = announcement} =
               Program.update_announcement(announcement, @update_attrs)

      assert announcement.body == "some updated body"
      assert announcement.show_until == ~D[2011-05-18]
    end

    test "update_announcement/2 with invalid data returns error changeset" do
      announcement = announcement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Program.update_announcement(announcement, @invalid_attrs)

      assert announcement == Program.get_announcement!(announcement.id)
    end

    test "delete_announcement/1 deletes the announcement" do
      announcement = announcement_fixture()
      assert {:ok, %Announcement{}} = Program.delete_announcement(announcement)
      assert_raise Ecto.NoResultsError, fn -> Program.get_announcement!(announcement.id) end
    end

    test "change_announcement/1 returns a announcement changeset" do
      announcement = announcement_fixture()
      assert %Ecto.Changeset{} = Program.change_announcement(announcement)
    end
  end
end
