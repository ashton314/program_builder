defmodule ProgramBuilderWeb.MeetingEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.NewMeetingForm
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  import Ecto.Changeset
  require Logger

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

  def handle_event("save", %{"new_meeting_form" => params}, socket) do
    events = ProgramBuilder.Program.create_events_from_generic(socket.assigns.events)
    IO.inspect(events, label: :events)

    params = Map.put(params, "event_ids", events)

    case ProgramBuilder.Program.create_meeting(params) do
      {:ok, new_meeting} ->
        {:stop,
         socket
         |> put_flash(:info, "Meeting plan created")
         |> redirect(
           to:
             Routes.meeting_path(
               ProgramBuilderWeb.Endpoint,
               :show,
               new_meeting.id
             )
         )}

      {:error, err} ->
        Logger.debug("Error saving: #{inspect(err)}")
        {:noreply, socket |> put_flash(:error, "There was a problem saving")}
    end

    {:noreply, socket}
  end

  def handle_info({:update_events, child, events}, state) do
    {:noreply, assign(state, :events, events)}
  end
end
