defmodule ProgramBuilderWeb.NewMeetingLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.NewMeetingForm
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  require Logger

  def render(assigns) do
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "new_live.html", assigns)
  end

  def mount(_params, socket) do
    socket =
      socket
      |> assign(:changeset, NewMeetingForm.changeset(%NewMeetingForm{}, %{}))
      |> assign(:events, [])
      |> assign(announcements: [])

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
    meeting = Map.put(params, "events", socket.assigns.events)
    IO.inspect(params, label: :params)
    case ProgramBuilder.Program.create_full_meeting(meeting) do
      {:ok, new_meeting} ->
        {:noreply,
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
        {:noreply, socket |> put_flash(:error, "There was a problem saving: #{inspect(err)}")}
    end
  end

  def handle_info({:update_events, _child, events}, state) do
    {:noreply, assign(state, :events, events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    IO.inspect({field, new_list}, label: :new_list_received)
    {:noreply, assign(socket, field, new_list)}
  end
end
