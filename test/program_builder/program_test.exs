defmodule ProgramBuilder.ProgramTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Program

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

  describe "meetings" do
    alias ProgramBuilder.Program.Meeting

    @valid_attrs %{
      accompanist: "some accompanist",
      chorester: "some chorester",
      closing_hymn: 42,
      conducting: "some conducting",
      date: ~D[2010-04-17],
      event_ids: [],
      opening_hymn: 42,
      presiding: "some presiding",
      sacrament_hymn: 42,
      topic: "some topic",
      visiting: "some visiting",
      announcements: ["foo"],
      callings: ["bar"],
      releases: ["baz"],
      stake_business: "",
      baby_blessings: ["zoop"],
      confirmations: ["qux"],
      other_ordinances: ["quxx"]
    }
    @update_attrs %{
      accompanist: "some updated accompanist",
      chorester: "some updated chorester",
      closing_hymn: 43,
      conducting: "some updated conducting",
      date: ~D[2011-05-18],
      event_ids: [],
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
      event_ids: nil,
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

    test "high-level get" do
      
    end

    test "list_meetings/0 returns all meetings" do
      meeting = meeting_fixture()
      assert Program.list_meetings() == [%{meeting | stake_business: nil}]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()
      assert Program.get_meeting!(meeting.id) == %{meeting | stake_business: nil}
    end

    test "create_meeting/1 with valid data creates a meeting" do
      assert {:ok, %Meeting{} = meeting} = Program.create_meeting(@valid_attrs)
      assert meeting.accompanist == "some accompanist"
      assert meeting.chorester == "some chorester"
      assert meeting.closing_hymn == 42
      assert meeting.conducting == "some conducting"
      assert meeting.date == ~D[2010-04-17]
      assert meeting.event_ids == []
      assert meeting.opening_hymn == 42
      assert meeting.presiding == "some presiding"
      assert meeting.sacrament_hymn == 42
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
      assert meeting.event_ids == []
      assert meeting.opening_hymn == 43
      assert meeting.presiding == "some updated presiding"
      assert meeting.sacrament_hymn == 43
      assert meeting.topic == "some updated topic"
      assert meeting.visiting == "some updated visiting"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_meeting(meeting, @invalid_attrs)
      assert %{meeting | stake_business: nil} == Program.get_meeting!(meeting.id)
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

  describe "event helpers" do
    alias ProgramBuilder.Program
    alias ProgramBuilder.Program.Event

    test "create_subtype" do
      {event, subtype} =
        Event.create_subtype(%{type: "music", title: "some title", performer: "foo"})

      from_repo = Program.get_event!(event.id)
      subtype_id = subtype.id

      assert event == from_repo
      assert %{type: "music", foreign_key: ^subtype_id} = event
    end

    test "create events from generic" do
      spec = [%{type: :music, title: "foo"}, %{type: :talk, subtopic: "baz"}]
      created = Program.create_events_from_generic(spec)

      assert length(created) == 2
    end
  end

  describe "event_ids" do
    alias ProgramBuilder.Program.Event

    @valid_attrs %{foreign_key: 42, type: "music"}
    @update_attrs %{foreign_key: 43, type: "generic"}
    @invalid_attrs %{foreign_key: nil, type: "not-a-valid-type"}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Program.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Program.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Program.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Program.create_event(@valid_attrs)
      assert event.foreign_key == 42
      assert event.type == "music"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Program.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Program.update_event(event, @update_attrs)
      assert event.foreign_key == 43
      assert event.type == "generic"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_event(event, @invalid_attrs)
      assert event == Program.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Program.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Program.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Program.change_event(event)
    end
  end
end
