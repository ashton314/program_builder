defmodule ProgramBuilderWeb.MeetingFormatterLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  require Logger

  def render(assigns) do
    ~L"""
    <%= @message %>
    """
  end

  def mount(%{path_params: %{"id" => id}}, socket) do
    meeting = Program.get_meeting!(id) |> Repo.preload([:events])
    Program.run_format(meeting)
    {:ok, assign(socket, message: "Your meeting is being rendered. The download will begin automatically.")}
  end

  def handle_info({:formatter_finished, result}, socket) do
    IO.inspect(result, label: :result)
    case result do
      {:ok, token} ->
        {:noreply, redirect(socket, to: Routes.download_path(ProgramBuilderWeb.Endpoint, :download, token))}
      _ ->
        {:noreply, assign(socket, message: "Something went wrong while rendering...")}
    end
  end
end
