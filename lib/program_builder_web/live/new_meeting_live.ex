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
    IO.inspect(socket.assigns.events, label: "events on save")
    events = ProgramBuilder.Program.create_events_from_generic(socket.assigns.events)

    params = Map.put(params, "event_ids", events)

    fields = ~w(announcements callings releases baby_blessings confirmations other_ordinances)a

    params =
      Enum.reduce(fields, params, fn field, acc ->
        Map.put(
          acc,
          to_string(field),
          Enum.map(socket.assigns[field] || [], fn {_key, val} -> val end)
        )
      end)

    IO.inspect(params, label: :params)

    case ProgramBuilder.Program.create_meeting(params) do
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

  def handle_info({:update_events, child, events}, state) do
    {:noreply, assign(state, :events, events)}
  end

  def handle_info({:list_update, field, new_list}, socket) do
    IO.inspect({field, new_list}, label: :new_list_received)
    {:noreply, assign(socket, field, new_list)}
  end
end
