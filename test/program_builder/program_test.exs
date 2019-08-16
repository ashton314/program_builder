defmodule ProgramBuilder.ProgramTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Event
  alias ProgramBuilder.People.Member

  @event_talk_valid_attrs %{
    type: "talk",
    raw_name: "Joe Schmoe",
    body: "Running tests",
    order_idx: 1
  }
  @event_talk_update_attrs %{
    type: "talk",
    raw_name: "Joe Schmoe Jr.",
    body: "Not failing tests",
    order_idx: 1
  }
  @event_invalid_attrs %{
    type: "some-type-i-dont-know-about",
    title: "Kaboom",
    body: "Running tests---please catch me",
    order_idx: 1
  }
  @event_music_valid_attrs %{
    type: "music",
    title: "Come, Thou Fount",
    body: "Ward Choir",
    order_idx: 2
  }

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
      topic: "some topic",
      visiting: "some visiting",
      announcements: ["foo"],
      callings: ["bar"],
      releases: ["baz"],
      stake_business: "",
      events: []
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
      topic: "some updated topic",
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
      topic: nil,
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
      assert Program.list_meetings() |> Repo.preload([:events]) == [%{meeting | stake_business: nil}]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()

      assert Program.get_meeting!(meeting.id) |> Repo.preload([:events]) ==
        %{meeting | stake_business: nil}
    end

    test "create_meeting/1 with valid data creates a meeting" do
      assert {:ok, %Meeting{} = meeting} = Program.create_meeting(@valid_attrs)
      assert meeting.accompanist == "some accompanist"
      assert meeting.chorester == "some chorester"
      assert meeting.closing_hymn == 42
      assert meeting.conducting == "some conducting"
      assert meeting.date == ~D[2010-04-17]
      assert meeting.events == []
      assert meeting.opening_hymn == 42
      assert meeting.presiding == "some presiding"
      assert meeting.topic == "some topic"
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
      assert meeting.events == []
      assert meeting.opening_hymn == 43
      assert meeting.presiding == "some updated presiding"
      assert meeting.topic == "some updated topic"
      assert meeting.visiting == "some updated visiting"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_meeting(meeting, @invalid_attrs)

      assert %{meeting | stake_business: nil} ==
               Program.get_meeting!(meeting.id) |> ProgramBuilder.Repo.preload([:events])
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
end
