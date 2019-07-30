defmodule ProgramBuilderWeb.EventsEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.NewMeetingForm
  import Ecto.Changeset

  def render(assigns) do
    ~L"""
    <h4>Meeting Events</h4>
    <%= for event <- @events do %>
        <div class="row">
            <div class="col">
                <%= event.type %>
            </div>
            <div class="col">
            </div>
            <div class="col">
            </div>
            <div class="col">
                <button class="btn btn-danger" phx-click="del_event" phx-value="<%= event.id %>">Remove</button>
            </div>
        </div>
    <% end %>
    <button class="btn btn-success" phx-click="add_event">Add Event</button>
    """
  end

  def mount(_params, socket) do
    socket =
      socket
      |> assign(:events, [])

    {:ok, socket}
  end

  def handle_event("del_event", event_id, socket) do
    socket =
      update(socket, :events, fn events ->
        Enum.reject(events, fn e -> to_string(e.id) == event_id end)
      end)

    {:noreply, socket}
  end

  def handle_event("add_event", _params, socket) do
    # Maybe instead I should have a list of changesets. That way, I
    # can update the changesets in a form in the list... hhmmm...
    new_event = %{
      id: System.unique_integer([:positive, :monotonic]),
      type: "talk",
      subtopic: "",
      visitor: "",
      member_id: nil,
      number: nil,
      performer: "",
      body: "",
      subtitle: "",
      title: ""
    }

    socket =
      socket
      |> update(:events, fn events -> [new_event | events] end)

    {:noreply, socket}
  end
end
