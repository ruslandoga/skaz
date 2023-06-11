defmodule SkazWeb.Router do
  use SkazWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SkazWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SkazWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", SkazWeb do
    pipe_through [:browser, :basic_auth]

    live "/messages", MessageLive.Index, :index
    live "/messages/:id", MessageLive.Index, :show
  end

  scope "/api/bot", SkazWeb do
    pipe_through :api

    post "/:token", BotController, :webhook
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:skaz, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SkazWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  def basic_auth(conn, _opts) do
    Plug.BasicAuth.basic_auth(conn, Skaz.basic_auth())
  end
end
