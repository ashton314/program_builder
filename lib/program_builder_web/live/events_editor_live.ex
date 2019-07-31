defmodule ProgramBuilderWeb.EventsEditorLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilderWeb.Helpers.NewMeetingForm
  import Ecto.Changeset
  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <h4>Meeting Events</h4>
    <%= for event_cs <- @events do %>
      <%= f = form_for event_cs, "#", [phx_change: :validate, class: "row", as: "event#{event_cs.data.id}"] %>

        <%# This is here so that the :validate knows which changeset to update %>
        <%= hidden_input f, :id %>

        <div class="col">
          <%= select f, :type, ["Talk": "talk", "Musical Number": "music", "Generic": "generic", "Note": "note"] %>
        </div>

        <%= if input_value(f, :type) == "talk" do %>
          <div class="col">
            <%= text_input f, :subtopic, placeholder: "Subtopic" %>
          </div>
          <div class="col">
            <%= text_input f, :visitor, placeholder: "Visitor Name" %>
          </div>
        <% end %>

        <%= if input_value(f, :type) == "music" do %>
          <div class="col">
            <%= number_input f, :number, placeholder: "Hymn Number" %>
          </div>
          <div class="col">
            <%= text_input f, :title, placeholder: "Title" %>
          </div>
          <div class="col">
            <%= text_input f, :performer, placeholder: "Performer" %>
          </div>
        <% end %>

        <%= if input_value(f, :type) == "generic" do %>
          <div class="col">
            <%= text_input f, :title, placeholder: "Title" %>
          </div>
          <div class="col">
            <%= text_input f, :subtitle, placeholder: "Subtitle" %>
          </div>
        <% end %>

        <%= if input_value(f, :type) == "note" do %>
          <div class="col">
            <%= text_input f, :title, placeholder: "Title" %>
          </div>
          <div class="col">
            <%= text_input f, :body, placeholder: "Body" %>
          </div>
        <% end %>

        <div class="col">
          <button class="btn btn-danger" phx-click="del_event" phx-value="<%= event_cs.data.id %>">Remove</button>
        </div>
      </form>
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
        Enum.reject(events, fn e -> to_string(e.data.id) == event_id end)
      end)

    {:noreply, socket}
  end

  def handle_event("add_event", _params, socket) do
    new_event = event_changeset(new_event(), %{})

    socket =
      socket
      |> update(:events, fn events -> events ++ [new_event] end)

    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    "event" <> event_id =
      params
      |> Map.keys()
      |> Enum.find(fn i -> Regex.match?(~r/^event(?:\d*)$/, i) end)

    event = params["event" <> event_id]

    {:noreply, update_event(socket, event)}
  end

  def update_event(socket, %{"id" => id} = event) do
    update(socket, :events, fn events ->
      Enum.map(events, fn evt ->
        if to_string(evt.data.id) == id do
          event_changeset(evt.data, event)
        else
          evt
        end
      end)
    end)
  end

  def new_event() do
    %{
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
  end

  def event_changeset(base, changes) do
    types = %{
      id: :integer,
      type: :string,
      subtopic: :string,
      visitor: :string,
      member_id: :integer,
      number: :integer,
      performer: :string,
      body: :string,
      subtitle: :string,
      title: :string
    }

    {base, types}
    |> cast(changes, Map.keys(types))
    |> validate_inclusion(:type, ~w|talk generic music note|)
  end
end
