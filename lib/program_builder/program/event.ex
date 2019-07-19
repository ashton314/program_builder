defmodule ProgramBuilder.Program.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProgramBuilder.Repo

  @subtypes ~w(music talk generic note)

  schema "events" do
    field :foreign_key, :integer
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:type, :foreign_key])
    |> validate_required([:type, :foreign_key])
    |> validate_inclusion(:type, @subtypes)
  end

  alias ProgramBuilder.Program.Event.Music

  @doc """
  Returns the list of music.

  ## Examples

      iex> list_music()
      [%Music{}, ...]

  """
  def list_music do
    Repo.all(Music)
  end

  @doc """
  Gets a single music.

  Raises `Ecto.NoResultsError` if the Music does not exist.

  ## Examples

      iex> get_music!(123)
      %Music{}

      iex> get_music!(456)
      ** (Ecto.NoResultsError)

  """
  def get_music!(id), do: Repo.get!(Music, id)

  @doc """
  Creates a music.

  ## Examples

      iex> create_music(%{field: value})
      {:ok, %Music{}}

      iex> create_music(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_music(attrs \\ %{}) do
    %Music{}
    |> Music.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a music.

  ## Examples

      iex> update_music(music, %{field: new_value})
      {:ok, %Music{}}

      iex> update_music(music, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_music(%Music{} = music, attrs) do
    music
    |> Music.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Music.

  ## Examples

      iex> delete_music(music)
      {:ok, %Music{}}

      iex> delete_music(music)
      {:error, %Ecto.Changeset{}}

  """
  def delete_music(%Music{} = music) do
    Repo.delete(music)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking music changes.

  ## Examples

      iex> change_music(music)
      %Ecto.Changeset{source: %Music{}}

  """
  def change_music(%Music{} = music) do
    Music.changeset(music, %{})
  end

  alias ProgramBuilder.Program.Event.Talk

  @doc """
  Returns the list of talks.

  ## Examples

      iex> list_talks()
      [%Talk{}, ...]

  """
  def list_talks do
    Repo.all(Talk)
  end

  @doc """
  Gets a single talk.

  Raises `Ecto.NoResultsError` if the Talk does not exist.

  ## Examples

      iex> get_talk!(123)
      %Talk{}

      iex> get_talk!(456)
      ** (Ecto.NoResultsError)

  """
  def get_talk!(id), do: Repo.get!(Talk, id)

  @doc """
  Creates a talk.

  ## Examples

      iex> create_talk(%{field: value})
      {:ok, %Talk{}}

      iex> create_talk(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_talk(attrs \\ %{}) do
    %Talk{}
    |> Talk.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a talk.

  ## Examples

      iex> update_talk(talk, %{field: new_value})
      {:ok, %Talk{}}

      iex> update_talk(talk, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_talk(%Talk{} = talk, attrs) do
    talk
    |> Talk.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Talk.

  ## Examples

      iex> delete_talk(talk)
      {:ok, %Talk{}}

      iex> delete_talk(talk)
      {:error, %Ecto.Changeset{}}

  """
  def delete_talk(%Talk{} = talk) do
    Repo.delete(talk)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking talk changes.

  ## Examples

      iex> change_talk(talk)
      %Ecto.Changeset{source: %Talk{}}

  """
  def change_talk(%Talk{} = talk) do
    Talk.changeset(talk, %{})
  end

  alias ProgramBuilder.Program.Event.Generic

  @doc """
  Returns the list of generic_events.

  ## Examples

      iex> list_generic_events()
      [%Generic{}, ...]

  """
  def list_generic_events do
    Repo.all(Generic)
  end

  @doc """
  Gets a single generic.

  Raises `Ecto.NoResultsError` if the Generic does not exist.

  ## Examples

      iex> get_generic!(123)
      %Generic{}

      iex> get_generic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_generic!(id), do: Repo.get!(Generic, id)

  @doc """
  Creates a generic.

  ## Examples

      iex> create_generic(%{field: value})
      {:ok, %Generic{}}

      iex> create_generic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_generic(attrs \\ %{}) do
    %Generic{}
    |> Generic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a generic.

  ## Examples

      iex> update_generic(generic, %{field: new_value})
      {:ok, %Generic{}}

      iex> update_generic(generic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_generic(%Generic{} = generic, attrs) do
    generic
    |> Generic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Generic.

  ## Examples

      iex> delete_generic(generic)
      {:ok, %Generic{}}

      iex> delete_generic(generic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_generic(%Generic{} = generic) do
    Repo.delete(generic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking generic changes.

  ## Examples

      iex> change_generic(generic)
      %Ecto.Changeset{source: %Generic{}}

  """
  def change_generic(%Generic{} = generic) do
    Generic.changeset(generic, %{})
  end

  alias ProgramBuilder.Program.Event.Note

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id), do: Repo.get!(Note, id)

  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{source: %Note{}}

  """
  def change_note(%Note{} = note) do
    Note.changeset(note, %{})
  end
end
