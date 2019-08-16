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
    _id = String.to_integer(id)
    {:ok, socket}
  end

  def handle_event("validate", %{"meeting" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_info({:update_events, _child, _events}, state) do
    {:noreply, state}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    {:noreply, assign(socket, field, new_list)}
  end
end
