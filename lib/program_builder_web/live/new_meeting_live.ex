defmodule ProgramBuilderWeb.NewMeetingLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    meeting = %Meeting{}
    socket =
      socket
      |> assign(meeting: meeting, changeset: Meeting.changeset(meeting, %{}))
      |> assign(announcements: [], callings: [], releases: [])

    {:ok, socket}
  end

  def handle_event("validate", %{"meeting" => params}, socket) do
    cs =
      socket.assigns.meeting
      |> Meeting.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: cs)}
  end

  def handle_info({:update_events, _child, _events}, state) do
    {:noreply, state}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
