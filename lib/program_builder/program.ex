defmodule ProgramBuilder.Program do
  @moduledoc """
  The Program context.
  """

  import Ecto.Query, warn: false
  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program.Meeting
  require Logger

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
  def get_meeting!(id), do: Repo.get!(Meeting, id) |> Repo.preload([:events])

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
  def layout_meeting(%Meeting{} = meeting, kind \\ :latex) when kind in ~w(latex markdown)a do
    ProgramBuilder.Meeting.Layout.latex(meeting)
  end

  @doc """
  Convert a meeting into a PDF.
  """
  @spec format_meeting(meeting :: Meeting.t()) :: {:ok, Path.t()} | {:error, String.t()}
  def format_meeting(%Meeting{} = meeting) do
    layout_meeting(meeting) |> ProgramBuilder.Utils.FormatLatex.format_string
  end

  def run_format(%Meeting{} = meeting) do
    caller = self()
    DynamicSupervisor.start_child(LatexFormat.Supervisor,
      {Task, fn ->
        Logger.debug("in spawned task #{inspect self()}, formatting...")
        resp = format_meeting(meeting)
        send caller, {:formatter_finished, resp}
      end})
  end

  alias ProgramBuilder.Program.Event

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
