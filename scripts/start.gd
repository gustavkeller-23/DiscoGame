extends Node

signal start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Menu.telaInicial = true
	if Global.Intro_tocar == false:
		$VideoStreamPlayer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogar_pressed() -> void:
	Global.Intro_tocar = false
	Menu.telaInicial = false
	get_tree().change_scene_to_file("res://scenes/levels.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_como_jogar_pressed() -> void:
	Global.Intro_tocar = false
	get_tree().change_scene_to_file("res://scenes/comoJogar.tscn")
