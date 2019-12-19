defmodule ProgramBuilderWeb.MemberController do
  use ProgramBuilderWeb, :controller

  alias ProgramBuilder.People
  alias ProgramBuilder.People.Member

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    members = People.list_members(user.unit_id)
    render(conn, "index.html", members: members)
  end

  def new(conn, _params) do
    changeset = People.change_member(%Member{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case People.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member created successfully.")
        |> redirect(to: Routes.member_path(conn, :show, member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = People.get_member!(id)
    render(conn, "show.html", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = People.get_member!(id)
    changeset = People.change_member(member)
    render(conn, "edit.html", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = People.get_member!(id)

    case People.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: Routes.member_path(conn, :show, member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = People.get_member!(id)
    {:ok, _member} = People.delete_member(member)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: Routes.member_path(conn, :index))
  end
end
