defmodule ProgramBuilderWeb.PageController do
  use ProgramBuilderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
