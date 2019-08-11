defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.EditMeetingForm
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

    # IO.inspect(meeting, label: :meeting_to_edit)

    fields = ~w(announcements callings releases baby_blessings confirmations other_ordinances)a

    socket =
      socket
      |> assign(:changeset, EditMeetingForm.changeset(meeting, %{}))
      |> assign(:initial_events, events)
      |> assign(:events, events)
      |> assign(meeting: meeting, meeting_id: id)
      |> assign(IO.inspect List.flatten Enum.map(fields, &[{&1, Map.get(meeting, &1, [])}]))

    {:ok, socket}
  end

  def handle_event("validate", %{"meeting" => params}, socket) do
    # changeset =
    #   %EditMeetingForm{}
    #   |> EditMeetingForm.changeset(params)
    #   |> Map.put(:action, :insert)

    # Ok, let's save this puppy.

    # First, delete all the old events
    # TODO: eventually it'd be nice to make this a diff so it's faster
    # Enum.map socket.assigns.meeting.event_ids, fn event -> Program.delete_event(event) end

    # Next, commit new events
    IO.inspect(socket.assigns.events, label: :events)
    events = ProgramBuilder.Program.create_events_from_generic(socket.assigns.events)
    params = Map.put(params, "event_ids", events)

    fields = ~w(announcements callings releases baby_blessings confirmations other_ordinances)a

    params =
      Enum.reduce(fields, params, fn field, acc ->
        Map.put(
          acc,
          to_string(field),
          Enum.map(socket.assigns[field] || [], fn {_key, val} -> val
            val -> val end)
        )
      end)

    IO.inspect(params, label: :update_params)

    case ProgramBuilder.Program.update_meeting(socket.assigns.meeting, params) do
      {:ok, updated} ->
        IO.inspect(updated, label: :updated_response_saved)
        {:noreply, socket}
      {:error, err} ->
        Logger.debug("Error saving: #{inspect(err)}")
        {:noreply, socket}
    end

  end

  def handle_info({:update_events, _child, events}, state) do
    {:noreply, assign(state, :events, events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
