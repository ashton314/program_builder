defmodule ProgramBuilderWeb.EventsEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Event
  alias ProgramBuilder.Program
  alias Ecto.Changeset
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "events_editor_live.html", assigns)
  end

  def mount(%{parent: parent_pid, events: events}, socket) do
    changesets = Enum.map(events, fn e -> Event.changeset(e, %{}) end)
    socket =
      socket
      |> assign(:events, events)
      |> assign(:event_changesets, changesets)
      |> assign(:parent_pid, parent_pid)

    {:ok, socket}
  end

  def handle_event("del_event", event_id, socket) do
    dead = String.to_integer(event_id)
    Program.delete_event(Program.get_event!(dead))

    send socket.assigns.parent_pid, {:update_events, self(), Enum.reject(socket.assigns.events, fn e -> e.id == dead end)}

    {:noreply, socket}
  end

  def handle_event("add_event", _params, socket) do
    {:ok, new_event} = Program.create_event()
    
    send(socket.assigns.parent_pid,
      {:update_events, self(), socket.assigns.events ++ [new_event]})

    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    "event" <> event_id =
      params
      |> Map.keys()
      |> Enum.find(fn i -> Regex.match?(~r/^event(?:\d*)$/, i) end)

    event = params["event" <> event_id]
    socket = update_event(socket, event)

    send(
      socket.assigns.parent_pid,
      {:update_events, self(), socket.assigns.events}
    )

    {:noreply, socket}
  end

  def update_event(socket, %{"id" => id} = event) do
    update(socket, :events, fn events ->
      Enum.map(events, fn evt ->
        if to_string(evt.id) == id do
          Event.changeset(evt, event) |> Changeset.apply_changes
        else
          evt
        end
      end)
    end)
  end

end
