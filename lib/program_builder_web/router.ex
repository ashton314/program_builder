defmodule ProgramBuilderWeb.Router do
  use ProgramBuilderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ProgramBuilderWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/new-meeting", MeetingEditorLive

    resources "/meetings", MeetingController
    resources "/announcements", AnnouncementController
    resources "/members", MemberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProgramBuilderWeb do
  #   pipe_through :api
  # end
end
