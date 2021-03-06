defmodule ProgramBuilderWeb.Router do
  use ProgramBuilderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {ProgramBuilderWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ProgramBuilder.Auth.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug ProgramBuilder.Auth.PutUser
  end

  scope "/", ProgramBuilderWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", AuthController, :new
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout
  end

  scope "/", ProgramBuilderWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    post "/meeting", MeetingController, :create
    live "/meetings/:id/edit", EditMeetingLive, session: [:user]
    live "/new-meeting", NewMeetingLive

    live "/meetings/:id", MeetingViewerLive, session: [:user]
    live "/meetings/:id/format", MeetingFormatterLive

    get "/download/:token", DownloadController, :download

    resources "/meetings", MeetingController, except: [:edit, :show]
    resources "/members", MemberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProgramBuilderWeb do
  #   pipe_through :api
  # end
end
