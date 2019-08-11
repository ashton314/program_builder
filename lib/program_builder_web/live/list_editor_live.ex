defmodule ProgramBuilderWeb.ListEditorLive do
  use Phoenix.LiveView

  import Ecto.Changeset
  import Phoenix.HTML.Form

  def render(assigns) do
    ~L"""
    <%= for {key, elem} <- @elements do %>
        <div class="row my-1">
            <div class="col">
                <%= elem %>
            </div>
            <div class="col-auto">
                <button class="btn btn-sm btn-outline-danger" phx-value="<%= key %>" phx-click="del_elem">Delete</button>
            </div>
        </div>
    <% end %>

    <%= f = form_for @changeset, "#", [phx_change: :validate, class: "form form-row form-inline", as: :elem] %>
    <div class="col">
        <%= text_input f, :new_elem, class: "form-control w-100" %>
    </div>
    <div class="col-auto">
        <button class="btn btn-outline-success my-3 mx-1" phx-click="add_elem" phx-value="<%= input_value(f, :new_elem) %>">Add</button>
    </div>
    </form>
    """
  end

  def mount(%{parent: parent_pid, field: field, value: value}, socket) do
    value = if is_nil(value), do: [], else: value

    socket =
      socket
      |> assign(:elements, Enum.map(value, &{System.unique_integer(), &1}))
      |> assign(:field, field)
      |> assign(:parent_pid, parent_pid)
      |> assign(:new_item, "")
      |> assign(:changeset, elem_changeset(%{}))

    {:ok, socket}
  end

  def handle_event("del_elem", elem_id, socket) do
    socket =
      update(socket, :elements, fn elements ->
        Enum.reject(elements, fn {id, _val} -> to_string(id) == elem_id end)
      end)

    send(socket.assigns.parent_pid, {:list_update, socket.assigns.field, socket.assigns.elements})

    {:noreply, socket}
  end

  def handle_event("validate", %{"elem" => params}, socket) do
    changeset = elem_changeset(%{}, params)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("add_elem", new_elem, socket) do
    socket =
      socket
      |> update(:elements, fn elements -> elements ++ [{System.unique_integer(), new_elem}] end)
      |> assign(:changeset, elem_changeset(%{}))

    send(socket.assigns.parent_pid, {:list_update, socket.assigns.field, socket.assigns.elements})

    {:noreply, socket}
  end

  def elem_changeset(base, changes \\ %{}) do
    types = %{new_elem: :string}

    {base, types}
    |> cast(changes, Map.keys(types))
  end
end
