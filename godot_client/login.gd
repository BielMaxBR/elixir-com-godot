extends Control

func _ready():
	Conection.connect("error", self, "_on_error")
	Conection.connect("connected", self, "_on_connect")

func _on_error(error):
	var erroLabel = $Painel/erro
	erroLabel.show()
	erroLabel.text = "Erro: " + str(error)
	

func _on_Button_pressed():
	Conection.login($Painel/host.text, $Painel/nome.text)

func _on_connect():
	get_tree().change_scene("res://Chat.tscn")
