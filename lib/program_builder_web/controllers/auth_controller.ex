defmodule ProgramBuilderWeb.AuthController do
  use ProgramBuilderWeb, :controller

  alias ProgramBuilder.Auth
  alias ProgramBuilder.Auth.User
  # alias ProgramBuilder.Auth.Pipeline
  alias ProgramBuilder.Auth.Guardian

  def new(conn, _) do
    changeset = Auth.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)
    if maybe_user do
      redirect(conn, to: "/meetings")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.auth_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Auth.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/meetings")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
