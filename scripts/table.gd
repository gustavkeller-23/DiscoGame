extends Node2D
 
 
func _ready() -> void:
	pass
 
 
func _process(_delta: float) -> void:
	pass
 
 
func downButton():
	$Yellow.play("colored")
	await get_tree().create_timer(0.5).timeout
	$Yellow.play("transparent")
 
 
func topButton():
	$Red.play("colored")
	await get_tree().create_timer(0.5).timeout
	$Red.play("transparent")
 
 
func leftButton():
	$Blue.play("colored")
	await get_tree().create_timer(0.5).timeout
	$Blue.play("transparent")
 
 
func rightButton():
	$Green.play("colored")
	await get_tree().create_timer(0.5).timeout
	$Green.play("transparent")
 
 
func definirImagens(img1: Array, img2: Array, img3: Array, img4: Array) -> void:
	# Escolhe aleatoriamente uma das imagens disponíveis para cada quadrante
	$UP.texture    = img1.pick_random() if not img1.is_empty() else null
	$RIGHT.texture = img2.pick_random() if not img2.is_empty() else null
	$DOWN.texture  = img3.pick_random() if not img3.is_empty() else null
	$LEFT.texture  = img4.pick_random() if not img4.is_empty() else null
	$UP.scale    = Vector2(0.2, 0.2)
	$RIGHT.scale = Vector2(0.2, 0.2)
	$LEFT.scale  = Vector2(0.2, 0.2)
	$DOWN.scale  = Vector2(0.2, 0.2)
