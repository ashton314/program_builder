defmodule ProgramBuilderWeb.MeetingControllerTest do
  use ProgramBuilderWeb.ConnCase

  alias ProgramBuilder.Program

  @create_attrs %{
    accompanist: "some accompanist",
    chorester: "some chorester",
    closing_hymn: 42,
    conducting: "some conducting",
    date: ~D[2010-04-17],
    events: [],
    opening_hymn: 42,
    presiding: "some presiding",
    sacrament_hymn: 42,
    topic: "some topic",
    visiting: "some visiting"
  }
  @update_attrs %{
    accompanist: "some updated accompanist",
    chorester: "some updated chorester",
    closing_hymn: 43,
    conducting: "some updated conducting",
    date: ~D[2011-05-18],
    events: [],
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
    events: nil,
    opening_hymn: nil,
    presiding: nil,
    sacrament_hymn: nil,
    topic: nil,
    visiting: nil
  }

  def fixture(:meeting) do
    {:ok, meeting} = Program.create_meeting(@create_attrs)
    meeting
  end

  describe "index" do
    test "lists all meetings", %{conn: conn} do
      conn = get(conn, Routes.meeting_path(conn, :index))
      assert html_response(conn, 200) =~ "Meeting Listing"
    end
  end

  describe "delete meeting" do
    setup [:create_meeting]

    test "deletes chosen meeting", %{conn: conn, meeting: meeting} do
      conn = delete(conn, Routes.meeting_path(conn, :delete, meeting))
      assert redirected_to(conn) == Routes.meeting_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.meeting_path(conn, :show, meeting))
      end
    end
  end

  defp create_meeting(_) do
    meeting = fixture(:meeting)
    {:ok, meeting: meeting}
  end
end
