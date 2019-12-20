defmodule ProgramBuilderWeb.EditMeetingLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "edit_meeting_live.html", assigns)
  end

  def mount(%{user: user = %{id: user_id, unit_id: unit_id}}, socket) do
    {:ok, assign(socket, meeting_id: nil, user: user, user_id: user_id, unit_id: unit_id)}
  end

  def handle_params(%{"id" => meeting_id}, _url, socket) do
    case Program.get_meeting(meeting_id, socket.assigns.user) do
      {:ok, meeting} -> {:noreply, assign(socket, meeting: meeting, meeting_id: meeting.id)}
      {:error, :not_found} -> {:noreply, redirect(put_flash(socket, :error, "Meeting not found"), to: "/login" )}
    end
  end
end
