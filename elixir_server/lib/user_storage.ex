defmodule ElixirServer.UserStorage do
  @moduledoc false
  use Agent

  defstruct users_pids: %{}

  def start_link(state) do
    Agent.start_link(fn -> %__MODULE__{state | users_pids: %{}} end, name: __MODULE__)
  end

  def store_pid(player_id, pid) do
    Agent.update(__MODULE__, fn state ->
      %__MODULE__{state | users_pids: Map.put(state.users_pids, player_id, pid)}
    end)
  end

  def get_pid(player_id) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state.users_pids, player_id)
    end)
  end

  def delete_pid(player_id) do
    Agent.update(__MODULE__, fn state ->
      %__MODULE__{state | users_pids: Map.drop(state.users_pids, [player_id])}
    end)
  end

  def get_all_players() do
    Agent.get(__MODULE__, fn state ->
      Enum.map(state.users_pids, fn {id, pid} ->
        ElixirServer.User.get_player(pid)
      end)
    end)
  end

end
