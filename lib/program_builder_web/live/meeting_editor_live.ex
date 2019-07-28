defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    {:ok, socket}
  end

  def changeset_new()
end
