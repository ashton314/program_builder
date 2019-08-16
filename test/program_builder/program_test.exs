defmodule ProgramBuilder.ProgramTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Event
  # alias ProgramBuilder.People.Member

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

  describe "events" do
    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@event_talk_valid_attrs)
        |> Program.create_event()

      event
    end

    test "create_event/1 with valid data creates an event" do
      assert {:ok, %Event{} = event} = Program.create_event(@event_talk_valid_attrs)
      assert event.type == "talk"
      assert event.raw_name == "Joe Schmoe"
    end

    test "create_event/1 with invalid data fails" do
      assert {:error, %Ecto.Changeset{}} = Program.create_event(@event_invalid_attrs)
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
      assert Program.list_meetings() |> Repo.preload([:events]) == [meeting]
    end

    test "get_meeting!/1 returns the meeting with given id" do
      meeting = meeting_fixture()

      assert Program.get_meeting!(meeting.id) |> Repo.preload([:events]) ==
        meeting
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

    test "create_meeting/1 with events creates a meeting and associated events" do
      events = [%{type: "talk", raw_name: "Joe Schmoe"}, %{type: "talk", raw_name: "Joe Schmoe Jr."}]
      meeting = meeting_fixture(%{events: events})

      assert ^meeting = Program.get_meeting!(meeting.id) |> Repo.preload([:events])

      [e1 | [_e2]] = meeting.events
      assert e1.meeting_id == meeting.id
    end

    test "update_meeting/2 with valid data updates the meeting" do
      meeting = meeting_fixture()
      updates = Map.put(@update_attrs, :events, [%{type: "talk", raw_name: "Joe Schmoe III"}])
      assert {:ok, %Meeting{} = meeting} = Program.update_meeting(meeting, updates)
      assert meeting.accompanist == "some updated accompanist"
      assert meeting.chorester == "some updated chorester"
      assert meeting.closing_hymn == 43
      assert meeting.conducting == "some updated conducting"
      assert meeting.date == ~D[2011-05-18]
      meeting_id = meeting.id
      assert [%Event{meeting_id: ^meeting_id, raw_name: "Joe Schmoe III"}] = meeting.events
      assert meeting.opening_hymn == 43
      assert meeting.presiding == "some updated presiding"
      assert meeting.topic == "some updated topic"
      assert meeting.visiting == "some updated visiting"
    end

    test "update_meeting/2 with invalid data returns error changeset" do
      meeting = meeting_fixture()
      assert {:error, %Ecto.Changeset{}} = Program.update_meeting(meeting, @invalid_attrs)

      assert meeting ==
               Program.get_meeting!(meeting.id) |> ProgramBuilder.Repo.preload([:events])

      assert {:error, %Ecto.Changeset{}} = Program.update_meeting(meeting, %{events: [@event_invalid_attrs]})
    end

    test "update_meeting/2 with exisiting event updates in-place" do
      meeting = meeting_fixture(%{events: [%{type: "talk", raw_name: "Joe Schmoe III"}]})
      [e1] = meeting.events
      updates = %{events: [Map.put(@event_talk_update_attrs, :id, e1.id), @event_music_valid_attrs]}
      assert {:ok, %Meeting{} = meeting} = Program.update_meeting(meeting, updates)
      [e1_1, e2] = meeting.events
      assert e1_1.id == e1.id
      assert e1_1.raw_name == "Joe Schmoe Jr."

      assert match?(@event_music_valid_attrs, e2)
    end

    test "delete_meeting/1 deletes the meeting and events" do
      meeting = meeting_fixture(%{events: [@event_talk_valid_attrs]})
      [e1] = meeting.events
      assert {:ok, %Meeting{}} = Program.delete_meeting(meeting)
      assert_raise Ecto.NoResultsError, fn -> Program.get_meeting!(meeting.id) end
      assert_raise Ecto.NoResultsError, fn -> Program.get_event!(e1.id) end
    end

    test "change_meeting/1 returns a meeting changeset" do
      meeting = meeting_fixture()
      assert %Ecto.Changeset{} = Program.change_meeting(meeting)
    end
  end
end
