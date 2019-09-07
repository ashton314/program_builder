defmodule ProgramBuilderWeb.LayoutView do
  use ProgramBuilderWeb, :view

  def login_or_logout_link(conn) do
    if Guardian.Plug.authenticated?(conn, []) do
      link "Logout", to: Routes.auth_path(conn, :logout), class: "nav-link"
    else
      link "Login", to: Routes.auth_path(conn, :new), class: "nav-link"
    end
  end
end
