defmodule ProgramBuilderWeb.MeetingController do
  use ProgramBuilderWeb, :controller

  alias ProgramBuilder.Program

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    meetings = Program.list_meetings(user.unit_id)

    render(put_layout(conn, {ProgramBuilderWeb.LayoutView, "app_wide.html"}), "index.html",
      meetings: meetings
    )
  end

  def create(conn, meeting) do
    user = Guardian.Plug.current_resource(conn)
    {:ok, _new_meeting} = Program.create_meeting(Map.put(meeting, "unit_id", user.unit_id))

    conn
    |> put_status(204)
  end

  def delete(conn, %{"id" => id}) do
    meeting = Program.get_meeting!(id)
    {:ok, _meeting} = Program.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
