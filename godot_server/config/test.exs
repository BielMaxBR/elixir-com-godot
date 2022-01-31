import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :godot_server, GodotServer.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "godot_server_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :godot_server, GodotServerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "tcZF9sj87hhV3i8bAUBabbFF+WEAmzxtz7GmKdGsA41JysGRWCt8pCUtN2zcMkWW",
  server: false

# In test we don't send emails.
config :godot_server, GodotServer.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
