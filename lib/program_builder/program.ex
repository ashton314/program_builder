defmodule ProgramBuilder.Program do
  @moduledoc """
  The Program context.
  """

  import Ecto.Query, warn: false
  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilder.Auth
  alias ProgramBuilder.Auth.User
  require Logger

  @doc """
  Returns all meetings given the unit_id.
  """
  @spec list_meetings(unit_id :: integer()) :: [Meeting]
  def list_meetings(unit_id) do
    q = from m in Meeting,
      where: m.unit_id == ^unit_id
    Repo.all(q)
  end

  @doc """
  Returns the list of meetings. Don't use. Only for admins

  ## Examples

      iex> list_meetings()
      [%Meeting{}, ...]

  """
  def list_all_meetings do
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
  def get_meeting!(id), do: Repo.get!(Meeting, id) |> Repo.preload([:events])

  @doc """
  Get a meeting, but check if the user is allowed to view.
  """
  def get_meeting(id, user) when is_integer(user) do
    case ProgramBuilder.Auth.get_user(user) do
      nil -> {:error, :unauthorized}
      %User{} = usr -> get_meeting(id, usr)
    end
  end
  def get_meeting(id, %User{} = user) do
    with meeting when not is_nil(meeting) <- Repo.get(Meeting, id),
         true <- Auth.Permissions.can_access?(user, meeting) do
      {:ok, meeting}
    else
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates a meeting.

  This will also create any events passed in the `events` field.
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
  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Meeting.
  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.
  """
  def change_meeting(%Meeting{} = meeting) do
    Meeting.changeset(meeting, %{})
  end

  @doc """
  Convert a meeting into a LaTeX or Markdown string.
  """
  def layout_meeting(%Meeting{} = meeting, kind \\ :latex, unit \\ %{}) when kind in ~w(latex markdown latex_conductor)a do
    case kind do
      :latex -> ProgramBuilder.Program.Layout.latex(meeting)
      :latex_conductor -> ProgramBuilder.Program.Layout.latex_conductor(meeting, unit)
    end
  end

  @doc """
  Convert a meeting into a PDF.
  """
  @spec format_meeting(meeting :: Meeting.t(), unit :: %{}, kind :: atom()) :: {:ok, Path.t()} | {:error, String.t()}
  def format_meeting(%Meeting{} = meeting, unit, kind \\ :latex) do
    layout_meeting(meeting, kind, unit) |> ProgramBuilder.Utils.FormatLatex.format_string
  end

  def run_format(%Meeting{} = meeting, unit \\ %{}, kind \\ :latex) do
    caller = self()
    DynamicSupervisor.start_child(LatexFormat.Supervisor,
      {Task, fn ->
        Logger.debug("in spawned task #{inspect self()}, formatting...")
        resp = format_meeting(meeting, unit, kind)
        send caller, {:formatter_finished, resp}
      end})
  end

  alias ProgramBuilder.Program.Event

  @doc """
  Push a new event into a meeting and return the event
  """
  def push_event!(%Meeting{} = meeting, attrs \\ %{}) do
    get_events = & &1.events
    # FIXME: this will break when you delete any event other than the
    # last one and try inserting a new event; it will be placed
    # somewhere in the middle of the list.
    count =
      meeting
      |> Repo.preload([:events])
      |> get_events.()
      |> Enum.count
    Map.merge(%{meeting_id: meeting.id, order_idx: count}, attrs) |> create_event()
  end

  @doc """
  Associates an event with a meeting. Event should not already have a meeting_id set
  """
  def associate_event!(%Meeting{} = meeting, %Event{meeting_id: m_id} = event) when is_nil m_id do
    get_events = & &1.events
    count =
      meeting
      |> Repo.preload([:events])
      |> get_events.()
      |> Enum.map(fn e -> e.order_idx end)
      |> Enum.max(fn -> 0 end)
    IO.inspect(count, label: :count)
    %{event | meeting_id: meeting.id, order_idx: count + 1} |> Repo.insert!()
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.
  """
  def get_event!(id), do: Repo.get!(Event, id)

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
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.
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
