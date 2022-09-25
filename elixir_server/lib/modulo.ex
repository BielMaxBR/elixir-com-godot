defmodule ElixirServer.Modulo do
  use Agent

  def start() do
    Agent.start_link(fn -> %{} end)
  end

  def add(pid, value) do
    Agent.update(pid, fn(state) ->
      Map.put(state,:algo, value)
    end)
  end

  def get(pid) do
    Agent.get(pid, fn(state) ->
      Map.get(state, :algo)
    end)
  end
end
