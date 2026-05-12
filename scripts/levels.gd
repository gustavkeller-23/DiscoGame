extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.medal[0] == null:
		$Medal_Easy.visible = false
	if Global.medal[1] == null:
		$Medal_Medium.visible = false
	if Global.medal[2] == null:
		$Medal_Hard.visible = false
	
	if Global.medal[0] != null:
		$Medal_Easy.visible = true
	if Global.medal[1] != null:
		$Medal_Medium.visible = true
	if Global.medal[2] != null:
		$Medal_Hard.visible = true
	
	if Global.medal[0] == 0:
		$Medal_Easy.texture = load("res://assets/Medalhas/Medalha_de_ouro.png")
	if Global.medal[1] == 0:
		$Medal_Medium.texture = load("res://assets/Medalhas/Medalha_de_ouro.png")
	if Global.medal[2] == 0:
		$Medal_Hard.texture = load("res://assets/Medalhas/Medalha_de_ouro.png")
	
	if Global.medal[0] == 1:
		$Medal_Easy.texture = load("res://assets/Medalhas/Medalha_de_prata.png")
	if Global.medal[1] == 1:
		$Medal_Medium.texture = load("res://assets/Medalhas/Medalha_de_prata.png")
	if Global.medal[2] == 1:
		$Medal_Hard.texture = load("res://assets/Medalhas/Medalha_de_prata.png")
	
	if Global.medal[0] == 2:
		$Medal_Easy.texture = load("res://assets/Medalhas/Medalha_de_bronze.png")
	if Global.medal[1] == 2:
		$Medal_Medium.texture = load("res://assets/Medalhas/Medalha_de_bronze.png")
	if Global.medal[2] == 2:
		$Medal_Hard.texture = load("res://assets/Medalhas/Medalha_de_bronze.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hard_level_pressed() -> void:
	Global.Dificuldade = 3
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_medium_level_pressed() -> void:
	Global.Dificuldade = 2
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_easy_level_pressed() -> void:
	Global.Dificuldade = 1
	get_tree().change_scene_to_file("res://scenes/main.tscn")



func _on_easy_level_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($Easy_Level, "scale", Vector2(1.1, 1.1), 0.1)


func _on_easy_level_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($Easy_Level, "scale", Vector2(1, 1), 0.1)


func _on_medium_level_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($Medium_Level, "scale", Vector2(1.1, 1.1), 0.1)


func _on_medium_level_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($Medium_Level, "scale", Vector2(1, 1), 0.1)


func _on_hard_level_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($Hard_Level, "scale", Vector2(1.1, 1.1), 0.1)


func _on_hard_level_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($Hard_Level, "scale", Vector2(1, 1), 0.1)
