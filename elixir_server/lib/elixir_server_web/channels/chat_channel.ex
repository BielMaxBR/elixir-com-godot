defmodule ElixirServerWeb.ChatChannel do
  @moduledoc false
  use ElixirServerWeb, :channel
  alias ElixirServer.User

  @impl true
  def join("chat:lobby", _payload, socket) do
    {:ok, pid} = User.start_link()
    socket = assign(socket, :pid, pid)

    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    pid = socket.assigns.pid
    position = User.get_position(pid)
    id = User.get_id(pid)
    broadcast!(socket, "joined", %{id: id, position: position})
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    IO.puts("[info] TERMINATED ID: #{User.get_id(socket.assigns.pid)}\n REASON: #{inspect reason}")
  end

  @impl true
  def handle_in("move", %{"body" => position}, socket) do
    pid = socket.assigns.pid
    id = User.get_id(pid)

    User.set_position(pid, position)

    broadcast!(socket, "move", %{id: id, position: position})

    {:noreply, socket}
  end
end
