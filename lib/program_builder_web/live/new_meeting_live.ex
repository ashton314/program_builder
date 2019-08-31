defmodule ProgramBuilderWeb.NewMeetingLive do
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

  def mount(_params, socket) do
    meeting = %Meeting{date: next_sunday(), announcements: ["If you are new to the ward, please meet with a member of the bishopric in the foyer after the meeting."]} |> Repo.preload([:events])
    {:ok, sacrament_hymn} = Program.create_event(%{type: "music", title: "", order_idx: 0})
    {:ok, sacrament} = Program.create_event(%{type: "generic", title: "Administration of the Sacrament", order_idx: 1})
    socket =
      socket
      |> assign(meeting: meeting, changeset: Meeting.changeset(meeting, %{}))
      |> assign(events: [sacrament_hymn, sacrament])
      |> assign(announcements: meeting.announcements, callings: meeting.callings, releases: meeting.releases)

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
      |> Map.put("announcements", Enum.map(socket.assigns.announcements, &MeetingView.strip_tuple_id/1))
      |> Map.put("callings", Enum.map(socket.assigns.callings, &MeetingView.strip_tuple_id/1))
      |> Map.put("releases", Enum.map(socket.assigns.releases, &MeetingView.strip_tuple_id/1))

    cs =
      socket.assigns.meeting
      |> Meeting.changeset(params)
      |> Map.put(:action, :insert)

    if cs.valid? do
      {:ok, meeting} = Program.create_meeting(params)

      socket =
        socket
        |> put_flash(:info, "New meeting created")
        |> redirect(to: Routes.live_path(ProgramBuilderWeb.Endpoint, ProgramBuilderWeb.MeetingViewerLive, meeting.id))

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

  def next_sunday() do
    Timex.today |> Timex.beginning_of_week |> Timex.add(Timex.Duration.from_days(7))
  end
end
