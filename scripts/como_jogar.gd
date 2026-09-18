extends Node2D

# ==============================================================================
# ESTADO GERAL DO TUTORIAL (COMO JOGAR)
# ==============================================================================

var arraySilabas: Array = [0, 1, 2, 3]
var silabaDri: Array = []
var pode_responder: bool = true
var parte: int = 1
var acertos: int = 0

# Animação do gesto para mobile (Dedo + Seta2)
var tween_dedo: Tween = null

# ==============================================================================
# VARIÁVEIS EXCLUSIVAS PARA DISPOSITIVOS MÓVEIS (TOUCH & SWIPE)
# ==============================================================================

var touch_start_pos: Vector2 = Vector2.ZERO
var is_touch_active: bool = false
var gesture_dispatched: bool = false
const SWIPE_THRESHOLD: float = 40.0


# ==============================================================================
# CICLO DE VIDA E MONTAGEM DO TUTORIAL
# ==============================================================================

func _ready() -> void:
	Menu.tocar_intro()
	montarTabuleiro()
	
	# Configuração inicial dos elementos visuais
	if is_mobile_device():
		$Seta.visible = false
		$Seta2.visible = false
		$Dedo.visible = false
	else:
		$Seta.visible = true
		$Seta2.visible = false
		$Dedo.visible = false
	
	await get_tree().create_timer(3.0).timeout
	
	# Etapa 1: Apresenta a primeira sílaba e aponta o comando para CIMA
	$Label.text = silabaDri[0]
	$Label.pivot_offset = $Label.size / 2.0
	$Label.scale = Vector2(0.1, 0.1)
	$Label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Label, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Label, "modulate:a", 1.0, 0.25)
	
	if is_mobile_device():
		animar_dedo_mobile(0) # Aponta e desliza para CIMA
	else:
		$Seta.play("toTop")


func montarTabuleiro() -> void:
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


# ==============================================================================
# FLUXO DAS ETAPAS DO TUTORIAL
# ==============================================================================

func Parte2() -> void:
	$Label.text = ""
	$Seta.play("default")
	parar_animacao_mobile()
	
	await get_tree().create_timer(3.0).timeout
	
	# Etapa 2: Apresenta a sílaba inferior e aponta o comando para BAIXO
	$Label.text = silabaDri[2]
	$Label.position = Vector2(331, 411)
	$Label.scale = Vector2(0.1, 0.1)
	$Label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Label, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Label, "modulate:a", 1.0, 0.25)
	
	if is_mobile_device():
		animar_dedo_mobile(2) # Aponta e desliza para BAIXO
	else:
		$Seta.play("toBot")


func Parte3() -> void:
	parar_animacao_mobile()
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/start.tscn")


func _executar_resposta_tutorial(resposta: int) -> void:
	processar_resposta(resposta)
	if resposta == 0 and parte == 1:
		_acerto(resposta)
		parar_animacao_mobile()
		$Seta.play("default")
		parte = 2
		Parte2()
	elif resposta == 2 and parte == 2:
		_acerto(resposta)
		parar_animacao_mobile()
		$Seta.play("default")
		Parte3()
	else:
		_erro(resposta)


func processar_resposta(resposta: int) -> void:
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
	
	# Intervalo antes de permitir nova ação
	await get_tree().create_timer(0.5).timeout
	pode_responder = true


func _acerto(resposta: int) -> void:
	$Acertou.play()
	acertos += 1
	var offset_dir = Vector2.ZERO
	match resposta:
		0: offset_dir = Vector2(0, -230)
		1: offset_dir = Vector2(240, 0)
		2: offset_dir = Vector2(0, 230)
		3: offset_dir = Vector2(-240, 0)
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Label, "position", $Label.position + offset_dir, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property($Label, "scale", Vector2(0.2, 0.2), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property($Label, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)


func _erro(resposta: int) -> void:
	var base_pos = Vector2(331, 411)
	var offset_impacto = Vector2.ZERO
	match resposta:
		0: offset_impacto = Vector2(0, -75)
		1: offset_impacto = Vector2(75, 0)
		2: offset_impacto = Vector2(0, 75)
		3: offset_impacto = Vector2(-75, 0)
	var tween = create_tween()
	tween.tween_property($Label, "position", base_pos + offset_impacto, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Label, "modulate", Color(1.0, 0.35, 0.35, 1.0), 0.12)
	tween.tween_property($Label, "position", base_pos, 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)


# ==============================================================================
# 📱 ANIMAÇÃO MOBILE (DEDO E SETA2)
# ==============================================================================

func animar_dedo_mobile(direcao: int) -> void:
	if tween_dedo and tween_dedo.is_valid():
		tween_dedo.kill()
	
	if not has_node("Seta2") or not has_node("Dedo"):
		return
	
	$Seta2.visible = true
	$Dedo.visible = true
	
	var pos_inicio: Vector2 = Vector2.ZERO
	var pos_fim: Vector2 = Vector2.ZERO
	
	if direcao == 0: # Cima
		$Seta2.position = Vector2(486, 230)
		$Seta2.rotation_degrees = 90 # Imagem base aponta para esquerda; rotacionada 90° aponta para cima
		pos_inicio = Vector2(486, 350)
		pos_fim = Vector2(486, 200)
	elif direcao == 2: # Baixo
		$Seta2.position = Vector2(486, 320)
		$Seta2.rotation_degrees = -90 # Rotacionada -90° aponta para baixo
		pos_inicio = Vector2(486, 200)
		pos_fim = Vector2(486, 350)
	
	$Dedo.position = pos_inicio
	$Dedo.modulate.a = 0.0
	
	# Loop contínuo: surge, desliza suavemente em direção à seta, desaparece e reinicia
	tween_dedo = create_tween().set_loops()
	tween_dedo.tween_property($Dedo, "modulate:a", 1.0, 0.25)
	tween_dedo.tween_property($Dedo, "position", pos_fim, 1.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_dedo.tween_property($Dedo, "modulate:a", 0.0, 0.25)
	tween_dedo.tween_callback(func(): if is_instance_valid($Dedo): $Dedo.position = pos_inicio)
	tween_dedo.tween_interval(0.4)


func parar_animacao_mobile() -> void:
	if tween_dedo and tween_dedo.is_valid():
		tween_dedo.kill()
	if has_node("Seta2"):
		$Seta2.visible = false
	if has_node("Dedo"):
		$Dedo.visible = false


# ==============================================================================
# 💻 MÓDULO EXCLUSIVO PARA DESKTOP (TECLADO / MOUSE)
# ==============================================================================

func _process(delta: float) -> void:
	_process_desktop(delta)


func _process_desktop(_delta: float) -> void:
	if not pode_responder:
		return

	# Leitura das teclas de seta do teclado (Desktop)
	if Input.is_action_just_pressed("top_button"):
		_executar_resposta_tutorial(0) # Cima
	elif Input.is_action_just_pressed("bottom_button"):
		_executar_resposta_tutorial(2) # Baixo
	elif Input.is_action_just_pressed("left_button"):
		_executar_resposta_tutorial(3) # Esquerda
	elif Input.is_action_just_pressed("right_button"):
		_executar_resposta_tutorial(1) # Direita


func _handle_desktop_mouse(event: InputEvent) -> void:
	if not pode_responder:
		return

	# Suporte opcional a arraste com o mouse em Desktop
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				touch_start_pos = event.position
				is_touch_active = true
				gesture_dispatched = false
			else:
				if is_touch_active and not gesture_dispatched:
					_avaliar_gesto_desktop(event.position - touch_start_pos)
				is_touch_active = false
				gesture_dispatched = false

	elif event is InputEventMouseMotion:
		if is_touch_active and not gesture_dispatched and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
			var delta = event.position - touch_start_pos
			if delta.length() >= SWIPE_THRESHOLD:
				gesture_dispatched = true
				_avaliar_gesto_desktop(delta)


func _avaliar_gesto_desktop(delta: Vector2) -> void:
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


# ==============================================================================
# 📱 MÓDULO EXCLUSIVO PARA DISPOSITIVOS MÓVEIS (MOBILE / TOUCH & SWIPE)
# ==============================================================================

func _unhandled_input(event: InputEvent) -> void:
	if not pode_responder:
		return

	# Eventos de toque na tela (Nativo de Dispositivos Móveis)
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		_handle_mobile_input(event)
	# Eventos de mouse no ambiente Desktop
	elif event is InputEventMouseButton or event is InputEventMouseMotion:
		_handle_desktop_mouse(event)


func _handle_mobile_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_pos = event.position
			is_touch_active = true
			gesture_dispatched = false
		else:
			if is_touch_active and not gesture_dispatched:
				_avaliar_gesto_mobile(event.position - touch_start_pos)
			is_touch_active = false
			gesture_dispatched = false

	elif event is InputEventScreenDrag:
		if is_touch_active and not gesture_dispatched:
			var delta = event.position - touch_start_pos
			if delta.length() >= SWIPE_THRESHOLD:
				gesture_dispatched = true
				_avaliar_gesto_mobile(delta)


func _avaliar_gesto_mobile(delta: Vector2) -> void:
	if delta.length() < SWIPE_THRESHOLD:
		return

	# Identificação do eixo predominante do gesto (Vertical vs Horizontal)
	if abs(delta.y) >= abs(delta.x):
		if delta.y < 0:
			_executar_resposta_tutorial(0) # Deslizar para Cima (Swipe Up)
		else:
			_executar_resposta_tutorial(2) # Deslizar para Baixo (Swipe Down)
	else:
		if delta.x > 0:
			_executar_resposta_tutorial(1) # Deslizar para a Direita (Swipe Right)
		else:
			_executar_resposta_tutorial(3) # Deslizar para a Esquerda (Swipe Left)


func is_mobile_device() -> bool:
	return OS.has_feature("android") or OS.has_feature("ios")

