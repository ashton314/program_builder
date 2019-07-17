defmodule ProgramBuilderWeb.AnnouncementController do
  use ProgramBuilderWeb, :controller

  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Announcement

  def index(conn, _params) do
    announcements = Program.list_announcements()
    render(conn, "index.html", announcements: announcements)
  end

  def new(conn, _params) do
    changeset = Program.change_announcement(%Announcement{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"announcement" => announcement_params}) do
    case Program.create_announcement(announcement_params) do
      {:ok, announcement} ->
        conn
        |> put_flash(:info, "Announcement created successfully.")
        |> redirect(to: Routes.announcement_path(conn, :show, announcement))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    announcement = Program.get_announcement!(id)
    render(conn, "show.html", announcement: announcement)
  end

  def edit(conn, %{"id" => id}) do
    announcement = Program.get_announcement!(id)
    changeset = Program.change_announcement(announcement)
    render(conn, "edit.html", announcement: announcement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    announcement = Program.get_announcement!(id)

    case Program.update_announcement(announcement, announcement_params) do
      {:ok, announcement} ->
        conn
        |> put_flash(:info, "Announcement updated successfully.")
        |> redirect(to: Routes.announcement_path(conn, :show, announcement))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", announcement: announcement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    announcement = Program.get_announcement!(id)
    {:ok, _announcement} = Program.delete_announcement(announcement)

    conn
    |> put_flash(:info, "Announcement deleted successfully.")
    |> redirect(to: Routes.announcement_path(conn, :index))
  end
end
