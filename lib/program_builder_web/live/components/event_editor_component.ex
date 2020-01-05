defmodule ProgramBuilderWeb.Components.EventEditorComponent do
  use Phoenix.LiveComponent

  alias ProgramBuilder.Program.Event

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

  def update(%{event: event}, socket) do
    socket = assign(socket, event: event, cs: Event.changeset(event, %{}))
    {:ok, socket}
  end
end
