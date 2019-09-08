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

  def delete(conn, %{"id" => id}) do
    meeting = Program.get_meeting!(id)
    {:ok, _meeting} = Program.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
