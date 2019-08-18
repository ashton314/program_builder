defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  alias ProgramBuilderWeb.MeetingView
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "meeting_editor_live.html", assigns)
  end

  def mount(%{path_params: %{"id" => id}}, socket) do
    meeting = Program.get_meeting!(id) |> Repo.preload([:events])

    socket =
      socket
      |> assign(meeting: meeting, changeset: Meeting.changeset(meeting, %{}))
      |> assign(events: meeting.events)
      |> assign(
        announcements: Enum.map(meeting.announcements, &MeetingView.add_tuple_id/1),
        callings: Enum.map(meeting.callings, &MeetingView.add_tuple_id/1),
        releases: Enum.map(meeting.releases, &MeetingView.add_tuple_id/1)
      )

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
    params =
      params
      |> Map.put("events", Enum.map(socket.assigns.events, fn e -> Map.from_struct(e) end))
      |> Map.put("events", Enum.map(socket.assigns.events, fn e -> Map.from_struct(e) end))
      |> Map.put("announcements", Enum.map(socket.assigns.announcements, &MeetingView.strip_tuple_id/1))
      |> Map.put("callings", Enum.map(socket.assigns.callings, &MeetingView.strip_tuple_id/1))
      |> Map.put("releases", Enum.map(socket.assigns.releases, &MeetingView.strip_tuple_id/1))

    cs =
      socket.assigns.meeting
      |> Meeting.changeset(params)
      |> Map.put(:action, :insert)

    if cs.valid? do
      {:ok, updated_meeting} = Program.update_meeting(socket.assigns.meeting, params)

      socket =
        socket
        |> put_flash(:info, "Meeting updated")
        |> redirect(to: Routes.meeting_path(ProgramBuilderWeb.Endpoint, :show, updated_meeting))

      {:noreply, socket}
    else
      socket =
        socket
        |> put_flash(:error, "Problem saving... reload page and try again")
      Logger.error("Problem saving event: #{inspect cs}")
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
