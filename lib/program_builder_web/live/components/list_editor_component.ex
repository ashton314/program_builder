defmodule ProgramBuilderWeb.Components.ListEditorComponent do
  use Phoenix.LiveComponent
  alias Ecto.Changeset
  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <div>
        <ul>
            <%= for {elem, idx} <- Stream.with_index(@lst) do %>
                <li><%= idx %>: <%= elem %> <button type="button" class="btn btn-outline-danger btn-sm" phx-click="remove_item" phx-value-idx="<%= idx %>">Remove</button></li>
            <% end %>
        </ul>
        <%= g = form_for @cs, "#", [as: :add, phx_change: :validate, class: "form"] %>
            <%= text_input g, :to_add, placeholder: "New Item" %>
            <button type="button" class="btn btn-outline-success btn-sm" phx-click="add_item">Add</button>
        </form>
    </div>
    """
  end

  def mount(socket) do
    socket =
      socket
      |> assign(lst: [], cs: add_changeset())

    {:ok, socket}
  end

  def update(%{key: key, lst: lst} = _assigns, socket) do
    socket = assign(socket, lst: lst, key: key)
    {:ok, socket}
  end

  def handle_event("remove_item", %{"idx" => idx}, socket) do
    new_list = List.delete_at(socket.assigns.lst, String.to_integer(idx))
    send self(), {:update_field, socket.assigns.key, new_list}
    {:noreply, socket}
  end

  def handle_event("add_item", _val, socket) do
    new_element = Changeset.apply_changes(socket.assigns.cs).to_add
    new_list = socket.assigns.lst ++ [new_element]
    send self(), {:update_field, socket.assigns.key, new_list}
    {:noreply, socket}
  end

  def handle_event("validate", val, socket) do
    {:noreply, assign(socket, cs: add_changeset(%{to_add: get_in(val, ["add", "to_add"])}))}
  end

  def add_changeset(params \\ %{}) do
    data = %{}
    types = %{to_add: :string}
    {data, types}
      |> Changeset.cast(params, Map.keys(types))
  end
end
