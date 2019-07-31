defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.NewMeetingForm
  import Ecto.Changeset

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    socket =
      socket
      |> assign(:changeset, NewMeetingForm.changeset(%NewMeetingForm{}, %{}))
      |> assign(:events, [])

    {:ok, socket}
  end

  def handle_event("validate", %{"new_meeting_form" => params}, socket) do
    changeset =
      %NewMeetingForm{}
      |> NewMeetingForm.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", params, socket) do
    IO.inspect(params, label: :params)
    IO.inspect(socket, label: :socket)

    {:noreply, socket}
  end
end
