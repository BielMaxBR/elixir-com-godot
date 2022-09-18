defmodule ElixirServerWeb.ChatChannelTest do
  use ElixirServerWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      ElixirServerWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(ElixirServerWeb.ChatChannel, "chat:lobby")

    %{socket: socket}
  end

  test "shout broadcasts to chat:lobby", %{socket: socket} do
    push(socket, "shout", %{"body" => "all"})
    assert_broadcast "shout", %{body: "all"}
  end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from!(socket, "broadcast", %{"some" => "data"})
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
