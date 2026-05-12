extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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


func definirImagens(img1, img2, img3, img4):
	$UP.texture    = img1[0]
	$RIGHT.texture = img2[0]
	$DOWN.texture  = img3[0]
	$LEFT.texture  = img4[0]
	
	$UP.scale = Vector2(0.2, 0.2)
	$RIGHT.scale = Vector2(0.2, 0.2)
	$LEFT.scale = Vector2(0.2, 0.2)
	$DOWN.scale = Vector2(0.2, 0.2)
