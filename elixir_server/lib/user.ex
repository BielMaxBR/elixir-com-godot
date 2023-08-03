defmodule ElixirServer.User do
  @moduledoc false
  use Agent
  alias ElixirServer.User
  defstruct [:id, position: %{x: 0, y: 0}]

  def start_link() do
    {:ok, pid} = Agent.start_link(fn ->
      %User{id: generate_player_id(), position: %{x: 0, y: 0}}
    end)
    {:ok, pid}
  end

  def add(pid, key, value) do
    Agent.update(pid, fn(state) ->
      Map.put(state, key, value)
    end)
  end

  def set_position(pid, position) do
    Agent.update(pid, fn(state) ->
      Map.put(state, :position, position)
    end)
  end

  def get_id(pid) do
    Agent.get(pid, fn(state) ->
      Map.get(state, :id)
    end)
  end

  def get_position(pid) do
    Agent.get(pid, fn(state) ->
      Map.get(state, :position)
    end)
  end

  defp generate_player_id do
    random_bytes = :crypto.strong_rand_bytes(16)
    Base.encode16(random_bytes)
  end
end
