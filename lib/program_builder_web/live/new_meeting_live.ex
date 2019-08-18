defmodule ProgramBuilderWeb.NewMeetingLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program  
  alias ProgramBuilder.Program.Meeting
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    # meeting = %Meeting{} |> Repo.preload([:events])
    {:ok, meeting} = Program.create_meeting(%{date: ~D[2019-01-01]})
    meeting = meeting |> Repo.preload([:events])
    socket =
      socket
      |> assign(meeting: meeting, changeset: Meeting.changeset(meeting, %{}))
      |> assign(events: meeting.events)
      |> assign(announcements: [], callings: [], releases: [])

    {:ok, socket}
  end

  def handle_event("validate", %{"meeting" => params}, socket) do
    cs =
      socket.assigns.meeting
      |> Meeting.changeset(params)
      |> Map.put(:action, :insert)
      |> Ecto.Changeset.update_change(:events, fn e_cs -> Enum.map(e_cs, &Ecto.Changeset.apply_changes/1) end)

    {:noreply, assign(socket, changeset: cs)}
  end

  def handle_info({:update_events, _child, events}, state) do
    {:noreply, assign(state, events: events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
