defmodule BoilerNameWeb.Router do
  use BoilerNameWeb, :router

  import BoilerNameWeb.Auth

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_current_user
  end

  scope "/", BoilerNameWeb do
    pipe_through :api

    get "/auth", AuthController, :index
    patch "/auth", AuthController, :update
    post "/auth/login", AuthController, :login
    post "/auth/register", AuthController, :register
    post "/auth/confirm_email", AuthController, :confirm_email
    post "/auth/forgot_password", AuthController, :forgot_password
    post "/auth/reset_password", AuthController, :reset_password
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BoilerNameWeb.Telemetry
    end
  end
end
