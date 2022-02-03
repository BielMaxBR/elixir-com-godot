extends Node

var socket : PhoenixSocket
var channel : PhoenixChannel
var presence : PhoenixPresence

signal error(erro)
signal message(message)
signal connected
signal disconnected

var user_name: String

func login(host: String, _user_name: String):
	
	user_name = _user_name
	
	socket = PhoenixSocket.new(host, {
	  params = {"ok": "ok"}
	})

	socket.connect("on_open", self, "_on_Socket_open")
	socket.connect("on_close", self, "_on_Socket_close")
	socket.connect("on_error", self, "_on_Socket_error")
	socket.connect("on_connecting", self, "_on_Socket_connecting")

	presence = PhoenixPresence.new()
	
	presence.connect("on_join", self, "_on_Presence_join")
	presence.connect("on_leave", self, "_on_Presence_leave")

	channel = socket.channel("chat:lobby", {}, presence)

	channel.connect("on_event", self, "_on_Channel_event")
	channel.connect("on_join_result", self, "_on_Channel_join_result")
	channel.connect("on_error", self, "_on_Channel_error")
	channel.connect("on_close", self, "_on_Channel_close")

	call_deferred("add_child", socket, true)

	socket.connect_socket()

func send(message: String):
	print(channel.push('shout', {"user": user_name, "body": message}))

func _on_Socket_open(payload):
	channel.join()
	print("_on_Socket_open: ", " ", payload)

func _on_Channel_event(event, payload, status):
	print("_on_channel_event:  ", event, ", ", status, ", ", payload.body)
	emit_signal("message", payload)

func _on_Socket_error(error):
	print(error)
	emit_signal("error", error)

func _on_Channel_join_result(status, result):
	print("_on_Channel_join_result:  ", status, result)
	channel.push("shout", {"body": "salve tmb"})
	emit_signal("connected")

func _on_Channel_error(error):
	print("_on_Channel_error: " + str(error))

func _on_Presence_leave():
	emit_signal("disconnected")

func _on_Socket_close(payload):
	print("_on_Socket_close: ", " ", payload)

func _on_Socket_connecting(is_connecting):
	print("_on_Socket_connecting: ", " ", is_connecting)

func _on_Channel_close(closed):
	print("_on_Channel_close: " + str(closed))

func _on_Presence_join(joins):
	print("_on_Presence_join: " + str(joins))
