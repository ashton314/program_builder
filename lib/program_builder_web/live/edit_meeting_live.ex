defmodule ProgramBuilderWeb.EditMeetingLive do
  use Phoenix.LiveView
  require Logger

  alias ProgramBuilder.Program
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilder.Repo

  def render(assigns) do
    # IO.inspect(assigns.meeting, label: :assigns_meeting)
    Phoenix.View.render(ProgramBuilderWeb.MeetingView, "edit_meeting_live.html", assigns)
  end

  def mount(%{user: user = %{id: user_id, unit_id: unit_id}}, socket) do
    socket =
      socket
      |> assign(meeting_id: nil, user: user, user_id: user_id, unit_id: unit_id)
      |> assign(changeset: Meeting.changeset(%Meeting{}, %{}))

    {:ok, socket}
  end

  def handle_params(%{"id" => meeting_id}, _url, socket) do
    case Program.get_meeting(meeting_id, socket.assigns.user) do
      {:ok, meeting} -> {:noreply, assign(socket, meeting: Repo.preload(meeting, [:events]), meeting_id: meeting.id, changeset: Meeting.changeset(meeting, %{}))}
      {:error, :not_found} -> {:noreply, redirect(put_flash(socket, :error, "Meeting not found"), to: "/login" )}
    end
  end

  def handle_event("validate", val, socket) do
    IO.inspect(val, label: :val_from_validate)
    {:noreply, socket}
  end

  def handle_event("save", val, socket) do
    IO.inspect(val, label: :val_from_save)
    {:noreply, socket}
  end

  def handle_info({:update_field, keyword, new_val}, socket) do
    # IO.inspect(socket.assigns.changeset, label: :changeset_before)
    # IO.inspect({keyword, new_val}, label: :keyword_new_val)
    socket =
      socket
      |> assign(changeset: Meeting.changeset(socket.assigns.changeset, %{keyword => new_val}))
    # IO.inspect(socket.assigns.changeset, label: :changeset_after)
    {:noreply, socket}
  end
end
