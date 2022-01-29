defmodule GodotChat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GodotChatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GodotChat.PubSub},
      # Start the Endpoint (http/https)
      GodotChatWeb.Endpoint
      # Start a worker by calling: GodotChat.Worker.start_link(arg)
      # {GodotChat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GodotChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GodotChatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
