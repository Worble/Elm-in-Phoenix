defmodule HelloWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> private_room_id, _params, socket) do
    case Phoenix.Token.verify(socket, "user salt", private_room_id, max_age: 86400) do
      {:ok, id} ->
        {:ok, socket}
      {:error, _} ->
        {:error, %{reason: "unauthorized"}}   
    end
    # if private_room_id == socket.id do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
  end

  def handle_in("new:msg", %{"id" => id, "body" => body}, socket) do
    broadcast! socket, "new:msg", %{id: id, body: body}
    #{:noreply, socket}
    {:reply, {:ok, %{id: id, body: body}}, socket}
  end
end