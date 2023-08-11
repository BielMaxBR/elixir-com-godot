defmodule ElixirServerWeb.ChatChannel do
  @moduledoc false
  use ElixirServerWeb, :channel
  alias ElixirServer.User
  alias ElixirServer.UserStorage

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
    %{id: id, position: position} = User.get_player(pid)
    UserStorage.store_pid(id, pid)

    push(socket, "init", %{ yourid: id, online_players: UserStorage.get_all_players() })
    broadcast_from!(socket, "joined", %{id: id, position: position})

    {:noreply, socket}
  end

  @impl true
  def terminate(reason, socket) do
    id = User.get_id(socket.assigns.pid)
    broadcast_from!(socket, "exited", %{id: id})
    # lembrar de apagar no db depois
    IO.puts("[info] TERMINATED ID: #{id}\n REASON: #{inspect reason}")
    UserStorage.delete_pid(id)
    User.stop(socket.assigns.pid)
  end

  @impl true
  def handle_in("move", %{"position" => position}, socket) do
    pid = socket.assigns.pid
    id = User.get_id(pid)

    User.set_position(pid, position)

    broadcast_from!(socket, "move", %{id: id, position: position})
    {:noreply, socket}
  end
end
