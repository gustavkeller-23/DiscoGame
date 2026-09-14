extends Node2D

signal yellowButton
signal blueButton
signal redButton
signal greenButton

var arraySilabas = [0,1,2,3]
var silabaDri = []
var pode_responder = true
var parte = 1

var silaba_ativa_idx_direcao: int = -1  # índice 0-3 (qual direção é a correta)
var aguardando_resposta: bool = false


var acertos = 0

# Variáveis para controle de arrastar dos dedos (swipe / drag)
var touch_start_pos: Vector2 = Vector2.ZERO
var is_touch_active: bool = false
var gesture_dispatched: bool = false
const SWIPE_THRESHOLD: float = 40.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	montarTabuleiro()
	await get_tree().create_timer(3).timeout
	
	$Label.text = silabaDri[0]
	$Seta.play("toTop")


func Parte2():
	$Label.text = ""
	$Seta.play("default")
	await get_tree().create_timer(3).timeout
	$Label.text = silabaDri[2]
	$Seta.play("toBot")


func Parte3():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/start.tscn")
	

func _unhandled_input(event: InputEvent) -> void:
	if not pode_responder:
		return

	# Suporte a toque na tela (Mobile)
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_pos = event.position
			is_touch_active = true
			gesture_dispatched = false
		else:
			if is_touch_active and not gesture_dispatched:
				_avaliar_gesto(event.position - touch_start_pos)
			is_touch_active = false
			gesture_dispatched = false

	elif event is InputEventScreenDrag:
		if is_touch_active and not gesture_dispatched:
			var delta = event.position - touch_start_pos
			if delta.length() >= SWIPE_THRESHOLD:
				gesture_dispatched = true
				_avaliar_gesto(delta)

	# Suporte a arrastar com o mouse (Desktop)
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				touch_start_pos = event.position
				is_touch_active = true
				gesture_dispatched = false
			else:
				if is_touch_active and not gesture_dispatched:
					_avaliar_gesto(event.position - touch_start_pos)
				is_touch_active = false
				gesture_dispatched = false

	elif event is InputEventMouseMotion:
		if is_touch_active and not gesture_dispatched and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
			var delta = event.position - touch_start_pos
			if delta.length() >= SWIPE_THRESHOLD:
				gesture_dispatched = true
				_avaliar_gesto(delta)


func _avaliar_gesto(delta: Vector2) -> void:
	if delta.length() < SWIPE_THRESHOLD:
		return

	if abs(delta.y) >= abs(delta.x):
		if delta.y < 0:
			_executar_resposta_tutorial(0) # Cima
		else:
			_executar_resposta_tutorial(2) # Baixo
	else:
		if delta.x > 0:
			_executar_resposta_tutorial(1) # Direita
		else:
			_executar_resposta_tutorial(3) # Esquerda


func _executar_resposta_tutorial(resposta: int) -> void:
	processar_resposta(resposta)
	if resposta == 0 and parte == 1:
		_acerto()
		parte = 2
		Parte2()
	elif resposta == 2 and parte == 2:
		_acerto()
		Parte3()


func _process(delta: float) -> void:
	if not pode_responder:
		return
	if Input.is_action_just_pressed("bottom_button"):
		_executar_resposta_tutorial(2)
	elif Input.is_action_just_pressed("top_button"):
		_executar_resposta_tutorial(0)
	elif Input.is_action_just_pressed("left_button"):
		_executar_resposta_tutorial(3)
	elif Input.is_action_just_pressed("right_button"):
		_executar_resposta_tutorial(1)
	
	if acertos == 2:
		acertos = acertos + 1


func processar_resposta(resposta):
	pode_responder = false
	match resposta:
		0:
			$Table.topButton()
		1:
			$Table.rightButton()
		2:
			$Table.downButton()
		3:
			$Table.leftButton()
	averiguarResposta(resposta)
	# Espera 0.5 segundos antes de aceitar outro clique
	await get_tree().create_timer(0.5).timeout
	pode_responder = true


func montarTabuleiro():
	definirImagens()


func definirImagens() -> void:
	var imagens1 = Global.array_dicionario[arraySilabas[0]].imagens
	var imagens2 = Global.array_dicionario[arraySilabas[1]].imagens
	var imagens3 = Global.array_dicionario[arraySilabas[2]].imagens
	var imagens4 = Global.array_dicionario[arraySilabas[3]].imagens
 
	silabaDri.clear()
	silabaDri.append(Global.array_dicionario[arraySilabas[0]].silaba)
	silabaDri.append(Global.array_dicionario[arraySilabas[1]].silaba)
	silabaDri.append(Global.array_dicionario[arraySilabas[2]].silaba)
	silabaDri.append(Global.array_dicionario[arraySilabas[3]].silaba)
 
	$Table.definirImagens(imagens1, imagens2, imagens3, imagens4)
 



func averiguarResposta(index):
	if not aguardando_resposta:
		return
	
	var label = get_node_or_null("LabelSilaba")
	if silabaDri[index] == label.text:
		_acerto()
		$Pontos.resposta_correta()
	else:
		$Errou.play()
		$Pontos.resposta_errada()
	
	await get_tree().create_timer(0.6).timeout
	var som = Global.array_silabas[arraySilabas[index]].som
	$Silaba_Sound.stream = load(som)
	$Silaba_Sound.play()


func _acerto() -> void:
	$Acertou.play()
	$Label.text = ""
	acertos = acertos + 1



func _on_change_setup_timeout() -> void:
	var label = get_node_or_null("LabelSilaba")
	if label:
		$ChangeSetup.wait_time = 0.5
		$ChangeSetup.start()
	else:
		if Global.Dificuldade == 2:
			$ChangeSetup.wait_time = 12
		if Global.Dificuldade == 3:
			$ChangeSetup.wait_time = 3
		$ChangeSetup.start()
		montarTabuleiro()



func _on_question_timeout() -> void:
	# Bloqueia se já há uma sílaba aguardando resposta
	if aguardando_resposta:
		return
	
	$Pontos.nova_pergunta()
	aguardando_resposta = true
	var label = Label.new()
	
	# texto da sílaba (ajuste conforme sua variável)
	var arrayNum = arraySilabas.pick_random()
	label.text = Global.array_silabas[arrayNum].silaba
	
	# posição na tela (exemplo)
	label.position = Vector2(380, 320)
	
	# opcional: tamanho/estilo
	label.size = Vector2(219, 137)
	label.add_theme_font_size_override("font_size", 100)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.name = "LabelSilaba"
	
	# adiciona na cena
	add_child(label)


func atribuir_medalaha():
	if Global.Dificuldade == 1:
		print($Pontos.qtdPontos())
		if $Pontos.qtdPontos() >= 180:
			Global.medal[0] = 0
		elif $Pontos.qtdPontos() >= 100:
			Global.medal[0] = 1
		else:
			Global.medal[0] = 2
		
	if Global.Dificuldade == 2:
		if $Pontos.qtdPontos() >= 170:
			Global.medal[1] = 0
		elif $Pontos.qtdPontos() >= 120:
			Global.medal[1] = 1
		else:
			Global.medal[1] = 2
	
	if Global.Dificuldade == 3:
		if $Pontos.qtdPontos() >= 140:
			Global.medal[2] = 0
		elif $Pontos.qtdPontos() >= 100:
			Global.medal[2] = 1
		else:
			Global.medal[2] = 2
