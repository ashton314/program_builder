defmodule ProgramBuilderWeb.PageControllerTest do
  use ProgramBuilderWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Program"
  end
end
