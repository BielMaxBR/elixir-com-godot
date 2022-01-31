defmodule GodotServer.Repo do
  use Ecto.Repo,
    otp_app: :godot_server,
    adapter: Ecto.Adapters.Postgres
end
