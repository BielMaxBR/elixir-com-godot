extends Control

func _ready():
	Conection.connect("message", self, "_on_message_received")
	Conection.connect("disconnected", self, "_on_disconnect")

func _on_message_received(message, user):
	$Chat.text = $Chat.text + "\n" + str(user) + " : " + str(message)

func _on_disconnect():
	get_tree().change_scene("res://login.tscn")


func _on_send_pressed():
	Conection.send($message.text)
