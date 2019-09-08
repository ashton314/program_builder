defmodule ProgramBuilder.Auth.PutUser do
  use Plug.Builder

  def init(opts \\ []) do
    opts
  end

  def call(conn, opts \\ []) do
    conn
    |> assign(:user, Guardian.Plug.current_resource(conn))
  end
end
