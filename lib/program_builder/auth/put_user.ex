defmodule ProgramBuilder.Auth.PutUser do
  use Plug.Builder

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts \\ []) do
    conn
    |> put_session(:user, Guardian.Plug.current_resource(conn))
  end
end
