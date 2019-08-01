defmodule ProgramBuilder.Program.EventTest do
  use ProgramBuilder.DataCase

  alias ProgramBuilder.Program.Event

  describe "music" do
    alias ProgramBuilder.Program.Event.Music

    @valid_attrs %{
      note: "some note",
      number: 42,
      performer: "some performer",
      title: "some title"
    }
    @update_attrs %{
      note: "some updated note",
      number: 43,
      performer: "some updated performer",
      title: "some updated title"
    }

    def music_fixture(attrs \\ %{}) do
      {:ok, music} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Event.create_music()

      music
    end

    test "list_music/0 returns all music" do
      music = music_fixture()
      assert Event.list_music() == [music]
    end

    test "get_music!/1 returns the music with given id" do
      music = music_fixture()
      assert Event.get_music!(music.id) == music
    end

    test "create_music/1 with valid data creates a music" do
      assert {:ok, %Music{} = music} = Event.create_music(@valid_attrs)
      assert music.note == "some note"
      assert music.number == 42
      assert music.performer == "some performer"
      assert music.title == "some title"
    end

    test "update_music/2 with valid data updates the music" do
      music = music_fixture()
      assert {:ok, %Music{} = music} = Event.update_music(music, @update_attrs)
      assert music.note == "some updated note"
      assert music.number == 43
      assert music.performer == "some updated performer"
      assert music.title == "some updated title"
    end

    test "delete_music/1 deletes the music" do
      music = music_fixture()
      assert {:ok, %Music{}} = Event.delete_music(music)
      assert_raise Ecto.NoResultsError, fn -> Event.get_music!(music.id) end
    end

    test "change_music/1 returns a music changeset" do
      music = music_fixture()
      assert %Ecto.Changeset{} = Event.change_music(music)
    end
  end

  describe "talks" do
    alias ProgramBuilder.Program.Event.Talk

    @valid_attrs %{subtopic: "some subtopic", visitor: "some visitor"}
    @update_attrs %{subtopic: "some updated subtopic", visitor: "some updated visitor"}

    def talk_fixture(attrs \\ %{}) do
      {:ok, talk} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Event.create_talk()

      talk
    end

    test "list_talks/0 returns all talks" do
      talk = talk_fixture()
      assert Event.list_talks() == [talk]
    end

    test "get_talk!/1 returns the talk with given id" do
      talk = talk_fixture()
      assert Event.get_talk!(talk.id) == talk
    end

    test "create_talk/1 with valid data creates a talk" do
      assert {:ok, %Talk{} = talk} = Event.create_talk(@valid_attrs)
      assert talk.subtopic == "some subtopic"
      assert talk.visitor == "some visitor"
    end

    test "update_talk/2 with valid data updates the talk" do
      talk = talk_fixture()
      assert {:ok, %Talk{} = talk} = Event.update_talk(talk, @update_attrs)
      assert talk.subtopic == "some updated subtopic"
      assert talk.visitor == "some updated visitor"
    end

    test "delete_talk/1 deletes the talk" do
      talk = talk_fixture()
      assert {:ok, %Talk{}} = Event.delete_talk(talk)
      assert_raise Ecto.NoResultsError, fn -> Event.get_talk!(talk.id) end
    end

    test "change_talk/1 returns a talk changeset" do
      talk = talk_fixture()
      assert %Ecto.Changeset{} = Event.change_talk(talk)
    end
  end

  describe "generic_events" do
    alias ProgramBuilder.Program.Event.Generic

    @valid_attrs %{subtitle: "some subtitle", title: "some title"}
    @update_attrs %{subtitle: "some updated subtitle", title: "some updated title"}

    def generic_fixture(attrs \\ %{}) do
      {:ok, generic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Event.create_generic()

      generic
    end

    test "list_generic_events/0 returns all generic_events" do
      generic = generic_fixture()
      assert Event.list_generic_events() == [generic]
    end

    test "get_generic!/1 returns the generic with given id" do
      generic = generic_fixture()
      assert Event.get_generic!(generic.id) == generic
    end

    test "create_generic/1 with valid data creates a generic" do
      assert {:ok, %Generic{} = generic} = Event.create_generic(@valid_attrs)
      assert generic.subtitle == "some subtitle"
      assert generic.title == "some title"
    end

    test "update_generic/2 with valid data updates the generic" do
      generic = generic_fixture()
      assert {:ok, %Generic{} = generic} = Event.update_generic(generic, @update_attrs)
      assert generic.subtitle == "some updated subtitle"
      assert generic.title == "some updated title"
    end

    test "delete_generic/1 deletes the generic" do
      generic = generic_fixture()
      assert {:ok, %Generic{}} = Event.delete_generic(generic)
      assert_raise Ecto.NoResultsError, fn -> Event.get_generic!(generic.id) end
    end

    test "change_generic/1 returns a generic changeset" do
      generic = generic_fixture()
      assert %Ecto.Changeset{} = Event.change_generic(generic)
    end
  end

  describe "notes" do
    alias ProgramBuilder.Program.Event.Note

    @valid_attrs %{body: "some body", title: "some title"}
    @update_attrs %{body: "some updated body", title: "some updated title"}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Event.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Event.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Event.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Event.create_note(@valid_attrs)
      assert note.body == "some body"
      assert note.title == "some title"
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Event.update_note(note, @update_attrs)
      assert note.body == "some updated body"
      assert note.title == "some updated title"
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Event.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Event.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Event.change_note(note)
    end
  end
end
