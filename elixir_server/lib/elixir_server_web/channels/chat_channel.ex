defmodule ElixirServerWeb.ChatChannel do
  use ElixirServerWeb, :channel

  @impl true
  def join("chat:lobby", _payload, socket) do
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
    broadcast!(socket, "shout", %{"body": body})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    nil
  end
end
