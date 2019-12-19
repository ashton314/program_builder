defmodule ProgramBuilderWeb.SingleEventEditorLive do
  use Phoenix.LiveView

  # alias ProgramBuilder.Program.Meeting
  # alias ProgramBuilderWeb.Helpers.NewMeetingForm
  # import Ecto.Changeset

  def render(assigns) do
    ~L"""
    <%= @event.type %>
    """
  end

  def mount(params, socket) do
    socket = socket
    IO.inspect(params, label: :params)

    {:ok, socket}
  end
end
