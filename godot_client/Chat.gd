extends Control

var chat
func _ready():
	chat = $ScrollContainer/HBoxContainer/Chat
	Conection.connect("message", self, "_on_message_received")
	Conection.connect("disconnected", self, "_on_disconnect")

func _on_message_received(payload):
	chat.text = chat.text + "\n" + str(payload.user) + " : " + str(payload.body)

func _on_disconnect():
	get_tree().change_scene("res://login.tscn")


func _on_send_pressed():
	Conection.send($message.text)
