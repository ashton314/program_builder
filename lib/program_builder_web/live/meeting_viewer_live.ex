defmodule ProgramBuilderWeb.MeetingViewerLive do
  use Phoenix.LiveView

  alias ProgramBuilder.Auth
  alias ProgramBuilder.Repo
  alias ProgramBuilder.Program
  alias ProgramBuilderWeb.Router.Helpers, as: Routes
  import Ecto.Changeset
  require Logger

  def render(assigns) do
    ProgramBuilderWeb.MeetingView.render("show.html", assigns)
  end

  def mount(%{path_params: %{"id" => id}, user: user}, socket) do
    # IO.inspect(user, label: :user_in_mount)
    meeting = Program.get_meeting!(id) |> Repo.preload([:events])
    {:ok, assign(socket, meeting: meeting, download_working: false, user: user, format_type: type_changeset(%{format_type: "latex"}))}
  end

  def handle_event("download", _params, socket) do
    user = socket.assigns.user
    unit = Auth.get_unit!(user.unit_id)
    IO.inspect(unit, label: :unit)
    cs_data = apply_changes(socket.assigns.format_type)
    type = cs_data.format_type |> String.to_existing_atom()
    Program.run_format(socket.assigns.meeting, unit, type)
    {:noreply, assign(socket, download_working: true)}
  end

  def handle_event("validate_type", %{"format_type" => type_map}, socket) do
    cs = type_changeset(socket.assigns.format_type.data, type_map)
    {:noreply, assign(socket, format_type: cs)}
  end

  def handle_info({:formatter_finished, result}, socket) do
    IO.inspect(result, label: :result)
    socket = assign(socket, download_working: false)
    case result do
      {:ok, token} ->
        {:noreply, redirect(socket, to: Routes.download_path(ProgramBuilderWeb.Endpoint, :download, token))}
      _ ->
        {:noreply, assign(socket, message: "Something went wrong while rendering...")}
    end
  end

  def type_changeset(base, changes \\ %{}) do
    types = %{format_type: :string}

    {base, types}
    |> cast(changes, Map.keys(types))
    |> validate_inclusion(:format_type, ~w(latex latex_conductor))
  end
end
