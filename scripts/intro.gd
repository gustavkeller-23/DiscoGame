extends VideoStreamPlayer

func _ready():
	if Global.Intro_tocar == true:
		$AnimationPlayer.play("FADE OUT")
