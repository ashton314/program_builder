defmodule ProgramBuilderWeb.NewMeetingLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program  
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    meeting = %Meeting{} |> Repo.preload([:events])
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

    {:noreply, assign(socket, changeset: cs)}
  end

  def handle_event("save", %{"meeting" => params}, socket) do
    params = Map.put(params, "events", Enum.map(socket.assigns.events, fn e -> Map.from_struct(e) end))
    IO.inspect(params, label: :params)
    cs =
      socket.assigns.meeting
      |> Meeting.changeset(params)
      |> Map.put(:action, :insert)

    if cs.valid? do
      {:ok, meeting} = Program.create_meeting(params)

      socket =
        socket
        |> put_flash(:info, "New meeting created")
        |> redirect(to: Routes.meeting_path(ProgramBuilderWeb.Endpoint, :show, meeting))

      {:noreply, socket}
    else
      {:noreply, assign(socket, changeset: cs)}
    end
  end

  def handle_info({:update_events, _child, events}, state) do
    {:noreply, assign(state, events: events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
