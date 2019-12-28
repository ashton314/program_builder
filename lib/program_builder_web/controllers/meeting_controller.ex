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

  @doc """
  Create a new meeting and return a redirect to edit it
  """
  def create(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    # Create a new meeting
    {:ok, meeting} = Program.create_meeting(%{unit_id: user.unit_id, date: Timex.today()})
    conn
    |> put_flash(:info, "New meeting created")
    |> redirect(to: Routes.live_path(ProgramBuilderWeb.Endpoint, ProgramBuilderWeb.EditMeetingLive, meeting.id))
  end

  def delete(conn, %{"id" => id}) do
    # TODO: This function deliberately left unused.
    user = Guardian.Plug.current_resource(conn)

    meeting = Program.get_meeting!(id)
    {:ok, _meeting} = Program.delete_meeting(meeting)

    conn
    |> put_flash(:info, "Meeting deleted successfully.")
    |> redirect(to: Routes.meeting_path(conn, :index))
  end
end
