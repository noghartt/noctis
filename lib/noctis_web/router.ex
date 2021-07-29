defmodule NoctisWeb.Router do
  use NoctisWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug Noctis.Auth.Context
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

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: NoctisWeb.Telemetry
    end
  end

  scope "/api" do
    pipe_through :graphql

    if Mix.env() == :dev do
      forward "/graphiql",
        Absinthe.Plug.GraphiQL,
        schema: NoctisWeb.GraphQL.Schema
    end

    forward "/graphql", Absinthe.Plug, schema: NoctisWeb.GraphQL.Schema
  end
end
