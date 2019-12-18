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
    visiting: "some visiting",
    unit_id: 0
  }
  # @update_attrs %{
  #   accompanist: "some updated accompanist",
  #   chorester: "some updated chorester",
  #   closing_hymn: 43,
  #   conducting: "some updated conducting",
  #   date: ~D[2011-05-18],
  #   events: [],
  #   opening_hymn: 43,
  #   presiding: "some updated presiding",
  #   sacrament_hymn: 43,
  #   topic: "some updated topic",
  #   visiting: "some updated visiting",
  #   unit_id: 0
  # }
  # @invalid_attrs %{
  #   accompanist: nil,
  #   chorester: nil,
  #   closing_hymn: nil,
  #   conducting: nil,
  #   date: nil,
  #   events: nil,
  #   opening_hymn: nil,
  #   presiding: nil,
  #   sacrament_hymn: nil,
  #   topic: nil,
  #   visiting: nil,
  #   unit_id: 0
  # }

  @test_unit_attrs %{name: "test unit"}
  @test_user_attrs %{unit_id: 0, username: "test", password: "test"}

  def fixture(kind, attrs \\ %{})
  def fixture(:meeting, unit) do
    {:ok, meeting} = Program.create_meeting(%{@create_attrs | unit_id: unit.id})
    meeting
  end
  def fixture(:user, unit), do: ProgramBuilder.Auth.create_user!(%{@test_user_attrs | unit_id: unit.id})
  def fixture(:unit, attrs), do: ProgramBuilder.Auth.create_unit!(Map.merge(@test_unit_attrs, attrs))

  describe "index" do
    setup [:scaffold_auth]
    test "lists all meetings", %{conn: conn} do
      conn = get(conn, Routes.meeting_path(conn, :index))
      assert html_response(conn, 200) =~ "Meeting Listing"
    end
  end

  describe "delete meeting" do
    setup [:scaffold_auth]

    test "deletes chosen meeting", %{conn: conn, meeting: meeting} do
      conn = delete(conn, Routes.meeting_path(conn, :delete, meeting))
      assert redirected_to(conn) == Routes.meeting_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.live_path(ProgramBuilderWeb.Endpoint, ProgramBuilderWeb.MeetingViewerLive, meeting.id))
      end
    end
  end

  describe "unit containment" do
    setup [:two_users]

    test "build meeting for user 1—user2 can't access", %{user1: user1, user2: user2} do
      assert true == false
    end

    test "listing meetings doesn't get other one's meetings", %{user1: user1, user2: user2} do
      assert true == false
    end

    test "trying to get other unit's meetings is 404", %{user1: user1, user2: user2} do
      assert true == false
    end

    test "other unit's member list is not visible" do
      # FIXME: move this into the member_controller_test.exs
      assert true == false
    end

    test "unit_id is an integer" do
      # FIXME: remove this *after* creating a migration to change the unit id column into an integer
      assert true == false
    end
  end

  defp two_users(_) do
    unit1 = fixture(:unit, %{name: "test unit 1"})
    user1 = fixture(:user, unit1)
    unit2 = fixture(:unit, %{name: "test unit 2"})
    user2 = fixture(:user, unit2)
    {:ok, unit1: unit1, user1: user1, unit2: unit2, user2: user2}
  end

  defp scaffold_auth(%{conn: conn}) do
    unit = fixture(:unit)
    user = fixture(:user, unit)
    meeting = fixture(:meeting, unit)

    # Note: this step takes a long time
    {:ok, token, _} = ProgramBuilder.Auth.Guardian.encode_and_sign(user, %{}, token_type: :access)
    conn =
      conn
      |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, meeting: meeting, unit: unit, user: user}
  end
end
