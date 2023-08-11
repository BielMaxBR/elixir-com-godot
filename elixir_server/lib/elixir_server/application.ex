defmodule ElixirServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixirServer.Repo,
      # Start the Telemetry supervisor
      ElixirServerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirServer.PubSub},
      # Start a worker by calling: ElixirServer.Worker.start_link(arg)
      # {ElixirServer.Worker, arg}
      {ElixirServer.UserStorage, %ElixirServer.UserStorage{}},
      # Start the Endpoint (http/https)
      ElixirServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
