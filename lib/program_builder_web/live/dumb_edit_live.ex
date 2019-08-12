defmodule ProgramBuilderWeb.DumbEditLive do
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
    setup_meeting(meeting, socket)
  end

  def setup_meeting(meeting, socket, code \\ :ok) do
    id = meeting.id

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
      |> assign(IO.inspect(List.flatten(Enum.map(fields, &[{&1, Map.get(meeting, &1, [])}]))))

    {code, socket}
  end

  def handle_event("validate", %{"meeting" => params}, socket) do
    changeset =
      %EditMeetingForm{}
      |> EditMeetingForm.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"meeting" => params}, socket) do
    # First, delete all the old events
    # TODO: eventually it'd be nice to make this a diff so it's faster
    # Enum.map socket.assigns.meeting.event_ids, fn event -> Program.delete_event(event) end

    # Next, commit new events
    IO.inspect(socket.assigns.events, label: :events)

    events =
      socket.assigns.events
      |> Enum.map(fn
      %Ecto.Changeset{} = c -> Ecto.Changeset.apply_changes(c)
      thing -> thing
    end)
    |> ProgramBuilder.Program.create_events_from_generic()

      params = Map.put(params, "event_ids", events)

      fields = ~w(announcements callings releases baby_blessings confirmations other_ordinances)a

      params =
        Enum.reduce(fields, params, fn field, acc ->
          Map.put(
            acc,
            to_string(field),
            Enum.map(socket.assigns[field] || [], fn
              {_key, val} -> val
              val -> val
            end)
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
    event_ids = ProgramBuilder.Program.create_events_from_generic(events)
    update = %{"event_ids" => event_ids}

    case ProgramBuilder.Program.update_meeting(state.assigns.meeting, update) do
      {:ok, updated} ->
        setup_meeting(updated, state, :noreply)

      {:error, err} ->
        Logger.debug("Error saving: #{inspect(err)}")
        {:noreply, state}
    end
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
