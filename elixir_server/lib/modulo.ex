defmodule ElixirServer.Modulo do
  use Agent

  def start_link(init_state \\ %{}) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def add(value) do
    Agent.update(__MODULE__, fn(state) ->
      Map.put(state,:chave, value)
    end)
  end

  def get() do
    Agent.get(__MODULE__, fn(state) ->
      Map.get(state, :chave)
    end)
  end
end
