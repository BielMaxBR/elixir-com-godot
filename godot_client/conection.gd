extends Node

var socket : PhoenixSocket
var channel : PhoenixChannel
var presence : PhoenixPresence

signal error
signal message
signal connected
signal disconnected

var user_name: String

func login(host: String, _user_name: String):
	socket = PhoenixSocket.new(host, {params = {"ok":"ok"}})
	socket.connect("on_error", self, "_on_Socket_error")
	
	presence = PhoenixPresence.new()
	presence.connect("on_join", self, "_on_Presence_join")
	presence.connect("on_leave", self, "_on_Presence_leave")

	channel = socket.channel("chat:lobby", {}, presence)
	channel.connect("on_event", self, "_on_Channel_event")
	channel.connect("on_join_result", self, "_on_Channel_join_result")
	
	user_name = _user_name
	
	call_deferred("add_child", socket, true)
	socket.connect_socket()

func send(message: String):
	channel.push('shout', {"user": user_name, "message": message})

func _on_Channel_event(event, payload, status):
	print("_on_channel_event:  ", event, ", ", status, ", ", payload)
func _on_Socket_error(error):
	print(error)
	emit_signal("error")

func _on_Channel_join_result():
	print('?')
	emit_signal("connected")

func _on_Presence_leave():
	emit_signal("disconnected")
