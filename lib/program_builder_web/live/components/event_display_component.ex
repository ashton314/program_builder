defmodule ProgramBuilderWeb.Components.EventDisplayComponent do
  use Phoenix.LiveComponent

  alias ProgramBuilder.Program.Event

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "event_display_component.html", assigns)
  end

  def mount(socket) do
    socket =
      socket
      |> assign(event: %Event{})
    {:ok, socket}
  end
end
