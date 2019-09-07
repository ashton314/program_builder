defmodule ProgramBuilderWeb.LayoutView do
  use ProgramBuilderWeb, :view

  def username(conn) do
    user = Guardian.Plug.current_resource(conn)
    user.username
  end

  def logged_in?(conn) do
    Guardian.Plug.authenticated?(conn, [])    
  end

  def login_or_logout_link(conn) do
    if logged_in?(conn) do
      link "Logout", to: Routes.auth_path(conn, :logout), class: "nav-link"
    else
      link "Login", to: Routes.auth_path(conn, :new), class: "nav-link"
    end
  end
end
