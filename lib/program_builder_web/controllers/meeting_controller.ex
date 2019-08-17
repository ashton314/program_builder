defmodule ProgramBuilderWeb.MeetingController do
  use ProgramBuilderWeb, :controller

  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Meeting

  def index(conn, _params) do
    meetings = Program.list_meetings()

    render(put_layout(conn, {ProgramBuilderWeb.LayoutView, "app_wide.html"}), "index.html",
      meetings: meetings
    )
  end

  def new(conn, _params) do
    changeset = Program.change_meeting(%Meeting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"meeting" => meeting_params}) do
    case Program.create_meeting(meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, "Meeting created successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    meeting = Program.get_meeting!(id)
    render(conn, "show.html", meeting: meeting)
  end

  def formatter(conn, %{"meeting_id" => id}) do
    meeting = Program.get_meeting!(id)
    # FIXME: keep working here
    render(conn, "show.html", meeting: meeting)
  end

  def edit(conn, %{"id" => id}) do
    meeting = Program.get_meeting!(id)
    changeset = Program.change_meeting(meeting)
    render(conn, "edit.html", meeting: meeting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "meeting" => meeting_params}) do
    meeting = Program.get_meeting!(id)

    case Program.update_meeting(meeting, meeting_params) do
      {:ok, meeting} ->
        conn
        |> put_flash(:info, "Meeting updated successfully.")
        |> redirect(to: Routes.meeting_path(conn, :show, meeting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", meeting: meeting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    meeting = Program.get_meeting!(id)
    {:ok, _meeting} = Program.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
