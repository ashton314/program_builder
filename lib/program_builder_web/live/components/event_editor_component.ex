defmodule ProgramBuilderWeb.Components.EventEditorComponent do
  use Phoenix.LiveComponent

  alias ProgramBuilder.Program.Event
  alias Ecto.Changeset

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "event_editor_component.html", assigns)
  end

  def mount(socket) do
    socket =
      socket
      |> assign(event: %Event{})
      |> assign(cs: Event.changeset(%Event{}, %{}))
    {:ok, socket}
  end

  def update(_params, socket) do
    socket = assign(socket, event: %Event{}, cs: Event.changeset(%Event{}, %{}))
    {:ok, socket}
  end

  def handle_event("validate_event", %{"event" => event}, socket) do
    socket = assign(socket, cs: Event.changeset(socket.assigns.event, event))
    {:noreply, socket}
  end

  def handle_event("add_event", %{"event" => event_params}, socket) do
    cs = Event.changeset(socket.assigns.event, event_params)
    if cs.valid? do
      send self(), {:add_event, Changeset.apply_changes(cs)}
      {:noreply, assign(socket, event: %Event{}, cs: Event.changeset(%Event{}, %{}))}
    else
      {:noreply, assign(socket, cs: cs)}
    end
  end
end
