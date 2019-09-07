defmodule ProgramBuilder.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Your session has expired.")
    |> Phoenix.Controller.redirect(to: "/login")
  end

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
