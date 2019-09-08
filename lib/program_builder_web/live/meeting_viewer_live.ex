defmodule ProgramBuilderWeb.MeetingViewerLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  require Logger

  def render(assigns) do
    ProgramBuilderWeb.MeetingView.render("show.html", assigns)
  end

  def mount(%{path_params: %{"id" => id}, user: user}, socket) do
    IO.inspect(user, label: :user_in_mount)
    meeting = Program.get_meeting!(id) |> Repo.preload([:events])
    {:ok, assign(socket, meeting: meeting, download_working: false, user: user)}
  end

  def handle_event("download", _params, socket) do
    Program.run_format(socket.assigns.meeting)
    {:noreply, assign(socket, download_working: true)}
  end

  def handle_event("download", _params, socket) do
    Program.run_format(socket.assigns.meeting)
    {:noreply, assign(socket, download_working: true)}
  end

  def handle_info({:formatter_finished, result}, socket) do
    IO.inspect(result, label: :result)
    socket = assign(socket, download_working: false)
    case result do
      {:ok, token} ->
        {:noreply, redirect(socket, to: Routes.download_path(ProgramBuilderWeb.Endpoint, :download, token))}
      _ ->
        {:noreply, assign(socket, message: "Something went wrong while rendering...")}
    end
  end
end
