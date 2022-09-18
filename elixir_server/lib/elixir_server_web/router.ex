defmodule ElixirServerWeb.Router do
  use ElixirServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirServerWeb do
    pipe_through :api
  end
end
