defmodule ProgramBuilderWeb.Components.EventEditorComponent do
  use Phoenix.LiveComponent

  alias ProgramBuilder.Program.Event
  import Ecto.Changeset

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

  def update(_assigns, socket) do
    {:ok, socket}
  end
end
