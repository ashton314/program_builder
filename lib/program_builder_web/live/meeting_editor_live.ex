defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.EditMeetingForm
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  import Ecto.Changeset
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "edit_live.html", assigns)
  end

  def mount(%{path_params: %{"id" => id}}, socket) do
    id = String.to_integer(id)
    meeting = Program.get_meeting!(id)

    events =
      meeting.event_ids
      |> Enum.map(&Program.get_subtype_from_event!/1)
      |> Enum.map(fn e -> Map.merge(ProgramBuilderWeb.EventsEditorLive.new_event(), e) end)
      |> Enum.map(&ProgramBuilderWeb.EventsEditorLive.event_changeset(&1, %{}))

    socket =
      socket
      |> assign(:changeset, EditMeetingForm.changeset(meeting, %{}))
      |> assign(:initial_events, events)
      |> assign(:events, events)
      |> assign(meeting: meeting, announcements: [], meeting_id: id)

    {:ok, socket}
  end

  def handle_event("validate", %{"edit_meeting_form" => params}, socket) do
    changeset =
      %EditMeetingForm{}
      |> EditMeetingForm.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_info({:update_events, child, events}, state) do
    {:noreply, assign(state, :events, events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    IO.inspect({field, new_list}, label: :new_list_received)
    {:noreply, assign(socket, field, new_list)}
  end
end
