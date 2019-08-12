defmodule ProgramBuilder.Program do
  @moduledoc """
  The Program context.
  """

  import Ecto.Query, warn: false
  alias ProgramBuilder.Repo

  alias ProgramBuilder.Program.Meeting

  @doc """
  Returns the list of meetings.

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_meetings do
    Repo.all(Meeting)
  end

  @doc """
  Gets a single meeting.

  Raises `Ecto.NoResultsError` if the Meeting does not exist.

  ## Examples

      iex> get_meeting!(123)
      %Meeting{}

      iex> get_meeting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meeting!(id), do: Repo.get!(Meeting, id)

  @doc """
  Creates a meeting.

  This will also create any events passed in the `events` field.

  ## Examples

      iex> create_meeting(%{field: value})
      {:ok, %Meeting{}}

      iex> create_meeting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meeting(attrs \\ %{}) do
    build_meeting(attrs)
    |> Repo.insert()
  end

  @doc """
  Builds a meeting. Essentially like `create_meeting`, but doesn't insert into the database.
  """
  def build_meeting(attrs \\ %{}) do
    %Meeting{}
    |> Meeting.changeset(attrs)
  end

  @doc """
  Updates a meeting.

  ## Examples

      iex> update_meeting(meeting, %{field: new_value})
      {:ok, %Meeting{}}

      iex> update_meeting(meeting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Meeting.

  ## Examples

      iex> delete_meeting(meeting)
      {:ok, %Meeting{}}

      iex> delete_meeting(meeting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.

  ## Examples

      iex> change_meeting(meeting)
      %Ecto.Changeset{source: %Meeting{}}

  """
  def change_meeting(%Meeting{} = meeting) do
    Meeting.changeset(meeting, %{})
  end

  alias ProgramBuilder.Program.Announcement

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements do
    Repo.all(Announcement)
  end

  @doc """
  Gets a single announcement.

  Raises `Ecto.NoResultsError` if the Announcement does not exist.

  ## Examples

      iex> get_announcement!(123)
      %Announcement{}

      iex> get_announcement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement!(id), do: Repo.get!(Announcement, id)

  @doc """
  Creates a announcement.

  ## Examples

      iex> create_announcement(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announcement.

  ## Examples

      iex> update_announcement(announcement, %{field: new_value})
      {:ok, %Announcement{}}

      iex> update_announcement(announcement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement(%Announcement{} = announcement, attrs) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Announcement.

  ## Examples

      iex> delete_announcement(announcement)
      {:ok, %Announcement{}}

      iex> delete_announcement(announcement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement(%Announcement{} = announcement) do
    Repo.delete(announcement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement changes.

  ## Examples

      iex> change_announcement(announcement)
      %Ecto.Changeset{source: %Announcement{}}

  """
  def change_announcement(%Announcement{} = announcement) do
    Announcement.changeset(announcement, %{})
  end

  alias ProgramBuilder.Program.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Retrieves a meeting with all fields prepopulated.
  """
  def get_full_meeting!(id) do
    base = get_meeting!(id)
    Map.put(base, :events, Enum.map(base.event_ids, &get_subtype_from_event!/1))
  end

  @doc """
  Update a meeting, given the entire struct
  """
  def update_full_meeting(%{events: events} = meeting) do
    event_ids = create_events_from_generic(events)
    meeting =
      meeting
      |> Map.put(:event_ids, event_ids)
      |> Map.take(~w(accompanist chorester closing_hymn conducting date event_ids opening_hymn presiding sacrament_hymn topic visiting invocation benediction announcements callings releases stake_business baby_blessings confirmations other_ordinances id inserted_at updated_at)a)
    update_meeting(Map.put(meeting, :__struct__, Meeting), meeting)
  end

  @doc """
  Given a struct with a `type` attribute and keys for all events,
  stores an event of that type and creates a corresponding event type
  to point to the subtype just created.
  """
  @spec create_events_from_generic([%{type: String.t()} | %Event.Generic{} | %Event.Music{} | %Event.Note{} | %Event.Talk{}]) :: [integer()]
  def create_events_from_generic([]), do: []

  def create_events_from_generic([spec | rest]) do
    {event, _subtype} = Event.create_subtype(Event.to_spec(spec))
    [event.id | create_events_from_generic(rest)]
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  def get_subtypes_from_ids([]), do: []
  def get_subtypes_from_ids([id | rest]) do
    [get_subtype_from_event!(id) | get_subtypes_from_ids(rest)]
  end

  @doc """
  Given an event_id, finds the subtype and returns that.
  """
  def get_subtype_from_event!(event_id) do
    event = Repo.get!(Event, event_id)

    case event.type do
      "generic" -> Event.get_generic!(event.foreign_key)
      "note" -> Event.get_note!(event.foreign_key)
      "talk" -> Event.get_talk!(event.foreign_key)
      "music" -> Event.get_music!(event.foreign_key)
    end
    |> Map.put(:type, event.type)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end
end
