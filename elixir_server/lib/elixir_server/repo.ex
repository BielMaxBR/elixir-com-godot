defmodule ElixirServer.Repo do
  use Ecto.Repo,
    otp_app: :elixir_server,
    adapter: Ecto.Adapters.Postgres
end
