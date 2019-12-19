defmodule ProgramBuilderWeb.MemberControllerTest do
  use ProgramBuilderWeb.ConnCase

  alias ProgramBuilder.People

  @test_unit_attrs %{name: "test unit"}
  @test_user_attrs %{unit_id: 0, username: "test", password: "test"}

  @create_attrs %{moved_in: ~D[2010-04-17], moved_out: ~D[2010-04-17], name: "some name", unit_id: 0}
  @update_attrs %{moved_in: ~D[2011-05-18], moved_out: ~D[2011-05-18], name: "some updated name", unit_id: 0}
  @invalid_attrs %{moved_in: nil, moved_out: nil, name: nil, unit_id: 0}

  def fixture(:member, unit) do
    {:ok, member} = People.create_member(%{@create_attrs | unit_id: unit.id})
    member
  end
  def fixture(:user, unit), do: ProgramBuilder.Auth.create_user!(%{@test_user_attrs | unit_id: unit.id})
  def fixture(:unit), do: ProgramBuilder.Auth.create_unit!(@test_unit_attrs)

  describe "index" do
    setup [:scaffold_auth]

    test "lists all members", %{conn: conn} do
      conn = get(conn, Routes.member_path(conn, :index))
      assert html_response(conn, 200) =~ "Member List"
    end
  end

  describe "new member" do
    setup [:scaffold_auth]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.member_path(conn, :new))
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "create member" do
    setup [:scaffold_auth]

    test "redirects to show when data is valid", %{conn: conn, unit: unit} do
      conn = post(conn, Routes.member_path(conn, :create), member: Map.put(@create_attrs, :unit_id, unit.id))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.member_path(conn, :show, id)

      conn = get(conn, Routes.member_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Member"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.member_path(conn, :create), member: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "edit member" do
    setup [:scaffold_auth]

    test "renders form for editing chosen member", %{conn: conn, member: member} do
      conn = get(conn, Routes.member_path(conn, :edit, member))
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "update member" do
    setup [:scaffold_auth]

    test "redirects when data is valid", %{conn: conn, member: member, unit: unit} do
      conn = put(conn, Routes.member_path(conn, :update, member), member: Map.put(@update_attrs, :unit_id, unit.id))
      assert redirected_to(conn) == Routes.member_path(conn, :show, member)

      conn = get(conn, Routes.member_path(conn, :show, member))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      conn = put(conn, Routes.member_path(conn, :update, member), member: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "delete member" do
    setup [:scaffold_auth]

    test "deletes chosen member", %{conn: conn, member: member} do
      conn = delete(conn, Routes.member_path(conn, :delete, member))
      assert redirected_to(conn) == Routes.member_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.member_path(conn, :show, member))
      end
    end
  end

  defp scaffold_auth(%{conn: conn}) do
    unit = fixture(:unit)
    user = fixture(:user, unit)
    member = fixture(:member, unit)

    # Note: this step takes a long time
    {:ok, token, _} = ProgramBuilder.Auth.Guardian.encode_and_sign(user, %{}, token_type: :access)
    conn =
      conn
      |> put_req_header("authorization", "bearer: " <> token)

    {:ok, conn: conn, member: member, unit: unit, user: user}
  end
end
