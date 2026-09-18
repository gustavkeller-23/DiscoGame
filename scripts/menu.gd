extends Node2D

var musica_intro = preload("res://assets/Audios/Intro.mp3")
var musica_game = preload("res://assets/Audios/Game.mp3")

enum TipoMusica { NENHUMA, INTRO, GAME }
var musica_atual: TipoMusica = TipoMusica.NENHUMA

var mouseOnMenu = false
var som: float = -7.0
var volume_ligado = true
var volume_na_tela = true

var mouse_dentro = false

var _fechando = false

var telaInicial: bool = false:
	set(new_value):
		telaInicial = new_value
		
		if telaInicial:
			_on_Inicio_Menu()
		else:
			_on_fora_Inicio()


func _ready():
	# Configura as trilhas para repetição contínua
	if musica_intro is AudioStreamMP3:
		musica_intro.loop = true
	if musica_game is AudioStreamMP3:
		musica_game.loop = true

	# Definindo o valor inicial do áudio no slider e no player de música de fundo
	$Menu/VSlider.value = som
	if has_node("SomDeFundo"):
		$SomDeFundo.volume_db = som
		$SomDeFundo.finished.connect(_on_som_de_fundo_finished)
	
	$HTTPRequest.request_completed.connect(_on_request_completed)


func _on_som_de_fundo_finished() -> void:
	if musica_atual != TipoMusica.NENHUMA and has_node("SomDeFundo"):
		$SomDeFundo.play(0.0)


# ==============================================================================
# CONTROLE DE MÚSICA DE FUNDO
# ==============================================================================

func tocar_intro() -> void:
	tocar_musica(TipoMusica.INTRO)


func tocar_game() -> void:
	tocar_musica(TipoMusica.GAME)


func parar_musica() -> void:
	musica_atual = TipoMusica.NENHUMA
	if has_node("SomDeFundo"):
		$SomDeFundo.stop()


func tocar_musica(tipo: TipoMusica) -> void:
	if not has_node("SomDeFundo"):
		return

	# Se a mesma música já estiver tocando (ex: Start <-> ComoJogar <-> Dificuldade), não reinicia
	if musica_atual == tipo and $SomDeFundo.playing:
		return

	musica_atual = tipo
	match tipo:
		TipoMusica.INTRO:
			$SomDeFundo.stream = musica_intro
			$SomDeFundo.play(0.0)
		TipoMusica.GAME:
			$SomDeFundo.stream = musica_game
			$SomDeFundo.play(0.0)
		TipoMusica.NENHUMA:
			$SomDeFundo.stop()


func _on_request_completed(_result, _response_code, _headers, _body):
	if _fechando:
		_fecharJogo()
	resetar()


func resetar():
	Global.Score = 0
	Global.erros = 0
	Global.TempoDeJogo_Min = 0
	Global.TempoDeJogo_Sec = 0
	Global.JogoConcluido = false
	_fechando = false


func _process(_delta):
	if mouseOnMenu:
		var posicao = get_global_mouse_position()
		$Leitor.position = posicao
		$Leitor.position.x += 60
		$Leitor.position.y += -10
	else:
		$Leitor.position = Vector2(-10000, -10000)

# Função para modificar o volume da música de fundo no slider (mantendo os demais sons inalterados)
func _on_v_slider_value_changed(value: float) -> void:
	if value <= -20.0:
		volume_ligado = false
		if has_node("SomDeFundo"):
			$SomDeFundo.volume_db = -80.0
		$Menu/button_volume/Volume_OFF.visible = true
		$Menu/button_volume/Volume_ON.visible = false
	else:
		volume_ligado = true
		som = value
		if has_node("SomDeFundo"):
			$SomDeFundo.volume_db = value
		$Menu/button_volume/Volume_ON.visible = true
		$Menu/button_volume/Volume_OFF.visible = false


func _on_button_volume_pressed() -> void:
	$Timer_volume.stop()
	if volume_ligado:
		$Menu/button_volume/Volume_OFF.visible = true
		$Menu/button_volume/Volume_ON.visible = false
		$Menu/VSlider.value = -20.0
		if has_node("SomDeFundo"):
			$SomDeFundo.volume_db = -80.0
		volume_ligado = false 
	else:
		$Menu/button_volume/Volume_OFF.visible = false
		$Menu/button_volume/Volume_ON.visible = true
		if som <= -20.0:
			som = -7.0
		$Menu/VSlider.value = som
		if has_node("SomDeFundo"):
			$SomDeFundo.volume_db = som
		volume_ligado = true


func _on_button_volume_mouse_entered():
	mouse_dentro = true
	$Timer_volume.start()
	mouseOnMenu = true
	$Leitor/texto.text = "VOLUME"
	$MenuFixoSom.visible = true
	$FundoMenu.visible = false


func _on_button_volume_mouse_exited():
	mouse_dentro = false
	$Timer_volume.stop()
	mouseOnMenu = false
	$MenuFixoSom.visible = false
	$FundoMenu.visible = true


func _on_button_sair_pressed() -> void:
	if telaInicial:
		$Timer_porta.stop()
		_fecharJogo()
	else:
		get_tree().change_scene_to_file("res://scenes/start.tscn")


func _fecharJogo():
	get_tree().quit()


func _on_button_sair_mouse_entered():
	mouse_dentro = true
	$Timer_porta.start()
	mouseOnMenu = true
	$Leitor/texto.text = "VOLTAR"
	$MenuFixoPorta.visible = true
	$FundoMenu.visible = false
	if telaInicial == true:
		$Leitor/texto.text = "SAIR"
		$Menu/button_sair/Aberta.visible = true
		$Menu/button_sair/Normal.visible = false


func _on_button_sair_mouse_exited():
	mouse_dentro = false
	$Timer_porta.stop()
	mouseOnMenu = false
	$MenuFixoPorta.visible = false
	$FundoMenu.visible = true
	if telaInicial == true:
		$Menu/button_sair/Aberta.visible = false
		$Menu/button_sair/Normal.visible = true


func _on_fora_Inicio():
	$Menu/button_sair/Aberta.visible = false
	$Menu/button_sair/Normal.visible = false
	$Menu/button_sair/Voltar.visible = true


func _on_Inicio_Menu():
	$Menu/button_sair/Aberta.visible = false
	$Menu/button_sair/Normal.visible = true
	$Menu/button_sair/Voltar.visible = false


#Envia dados para plataforma
func _postData():
	var data = {
		"alunoId": int(Global.studentId),
		"jogoId": int(Global.gameId),
		"minutos": Global.TempoDeJogo_Min,
		"segundos": Global.TempoDeJogo_Sec,
		"concluido": Global.JogoConcluido,
		"pontos": Global.Score,
		"erros": Global.erros
	}
	var jsonData = JSON.stringify(data)
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + Global.token
	]
	$HTTPRequest.request(
		"https://192.168.122.123/api/historicos",
		headers,
		HTTPClient.METHOD_POST,
		jsonData
	)


func _on_timer_porta_timeout() -> void:
	#if telaInicial == true:
		#Audios.tocar_audio("res://assets/audios/sair_do_jogo.ogg", self)
	#else:
		#Audios.tocar_audio("res://assets/audios/voltar.ogg", self)
	$Timer_porta.stop()


func _on_timer_volume_timeout() -> void:
	#Audios.tocar_audio("res://assets/audios/volume.ogg", self)
	$Timer_volume.stop()


func is_mouse_inside() -> bool:
	return mouse_dentro
