import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :tests, Tests.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "tests_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tests, TestsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VzCNohXuv8Z1OqGRvwal6cwiZLa+uk/QYrFr6py0RPfSFQvRX1Mq3hFbBeMkTvwJ",
  server: false

# In test we don't send emails.
config :tests, Tests.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
