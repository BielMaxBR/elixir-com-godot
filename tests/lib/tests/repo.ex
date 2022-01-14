defmodule Tests.Repo do
  use Ecto.Repo,
    otp_app: :tests,
    adapter: Ecto.Adapters.Postgres
end
