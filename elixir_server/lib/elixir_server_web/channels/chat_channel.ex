defmodule ElixirServerWeb.ChatChannel do
  use ElixirServerWeb, :channel

  @impl true
  def join("chat:lobby", _payload, socket) do
    # {:ok, pid} = ElixirServer.Modulo.start()
    # socket = assign(socket, :pid, "a")
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", %{"body" => body}, socket) do
    broadcast!(socket, "shout", %{body: body})
    # ElixirServer.Modulo.add(socket.assigns.pid, body)
    # IO.puts(ElixirServer.Modulo.get(socket.assigns.pid))
    {:noreply, socket}
  end

  @impl true
  def handle_in("move", %{"body" => body}, socket) do
    ElixirServer.Modulo.add(body)
    broadcast!(socket, "move", %{"speed" => ElixirServer.Modulo.get(), "position" => %{x: 0, y: 12}})
    {:noreply, socket}
  end
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    nil
  end
end
