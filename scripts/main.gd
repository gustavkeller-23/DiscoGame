extends Node

signal yellowButton
signal blueButton
signal redButton
signal greenButton

# Índices sorteados do array_dicionario global (0 a 17)
var arraySilabas: Array = []
# Sílabas correspondentes aos 4 quadrantes [cima, direita, baixo, esquerda]
var silabaDri: Array = []

# Pool global de sílabas para evitar repetições no tabuleiro
var pool_dicionario: Array = []

# Fila de sorteio local para evitar repetições consecutivas de perguntas
var fila_perguntas_locais: Array = []
var ultima_silaba_idx_local: int = -1

# Controle de troca de tabuleiro no nível médio
var troca_tabuleiro_pendente: bool = false

var pode_responder: bool = true
var aguardando_resposta: bool = false
var acertos: int = 0
const TOTAL_ETAPAS: int = 10

# Índice do array_dicionario da sílaba que está sendo perguntada no momento
var arrayNum_atual: int = -1

# Variáveis para controle de arrastar dos dedos (swipe / drag)
var touch_start_pos: Vector2 = Vector2.ZERO
var is_touch_active: bool = false
var gesture_dispatched: bool = false
const SWIPE_THRESHOLD: float = 40.0


func _ready() -> void:
	Menu.tocar_game()
	montarTabuleiro()
	atualizar_etapas()

	$TimerQuestion.one_shot = true
	$ChangeSetup.one_shot = true

	# Configurações de início por dificuldade:
	if Global.Dificuldade == 1:
		# Fácil: 4 sílabas fixas do início ao fim (não troca o tabuleiro)
		$ChangeSetup.stop()
		$TimerQuestion.start(2.0)

	elif Global.Dificuldade == 2:
		# Médio: agenda troca de tabuleiro após 12 segundos (aguardando acerto para trocar)
		$ChangeSetup.start(12.0)
		$TimerQuestion.start(2.0)

	elif Global.Dificuldade == 3:
		# Difícil: troca o tabuleiro a cada acerto (não usa timer periódico)
		$ChangeSetup.stop()
		$TimerQuestion.start(2.0)


# ─────────────────────────────────────────
# ENTRADA DE DADOS (MOBILE / TOUCH & DESKTOP)
# ─────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	if not pode_responder or not aguardando_resposta:
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

	# Determina a direção predominante do arrasto
	if abs(delta.y) >= abs(delta.x):
		if delta.y < 0:
			processar_resposta(0) # Cima
		else:
			processar_resposta(2) # Baixo
	else:
		if delta.x > 0:
			processar_resposta(1) # Direita
		else:
			processar_resposta(3) # Esquerda


func _process(_delta: float) -> void:
	if not pode_responder or not aguardando_resposta:
		return

	# Controles de teclado para Desktop
	if Input.is_action_just_pressed("top_button"):
		processar_resposta(0)
	elif Input.is_action_just_pressed("bottom_button"):
		processar_resposta(2)
	elif Input.is_action_just_pressed("left_button"):
		processar_resposta(3)
	elif Input.is_action_just_pressed("right_button"):
		processar_resposta(1)


# ─────────────────────────────────────────
# PROCESSAMENTO E VERIFICAÇÃO DE RESPOSTAS
# ─────────────────────────────────────────

func processar_resposta(resposta: int) -> void:
	if not pode_responder or not aguardando_resposta:
		return

	pode_responder = false

	# Anima o quadrante correspondente no tabuleiro
	match resposta:
		0:
			$Table.topButton()
		1:
			$Table.rightButton()
		2:
			$Table.downButton()
		3:
			$Table.leftButton()

	await averiguarResposta(resposta)


func averiguarResposta(index: int) -> void:
	var label = get_node_or_null("LabelSilaba")
	if label == null:
		pode_responder = true
		return

	# Verifica se a resposta foi correta
	if silabaDri[index] == label.text:
		# === RESPOSTA CORRETA ===
		$Pontos.resposta_correta()
		$Acertou.play()
		acertos += 1
		atualizar_etapas()
		aguardando_resposta = false

		# Direção do quadrante selecionado para o efeito de voar em direção à roda
		var offset_direcao = Vector2.ZERO
		match index:
			0: # Cima (Vermelho)
				offset_direcao = Vector2(0, -230)
			1: # Direita (Verde)
				offset_direcao = Vector2(240, 0)
			2: # Baixo (Amarelo)
				offset_direcao = Vector2(0, 230)
			3: # Esquerda (Azul)
				offset_direcao = Vector2(-240, 0)

		# Efeito visual: o texto vai em direção à roda, encolhendo e desaparecendo
		var tween_acerto = create_tween().set_parallel(true)
		tween_acerto.tween_property(label, "position", label.position + offset_direcao, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween_acerto.tween_property(label, "scale", Vector2(0.2, 0.2), 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween_acerto.tween_property(label, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

		await tween_acerto.finished
		if is_instance_valid(label):
			label.queue_free()

		# Pronuncia a sílaba correta com som educativo
		$Silaba_Sound.stream = Global.array_dicionario[arraySilabas[index]].som
		$Silaba_Sound.play()

		# Aguarda a pronúncia ser falada naturalmente
		await get_tree().create_timer(1.1).timeout

		# Checa condição de vitória
		if acertos >= TOTAL_ETAPAS:
			$TimerQuestion.stop()
			$ChangeSetup.stop()
			Global.Score = int($Pontos.qtdPontos())
			Global.JogoConcluido = true
			Menu.parar_musica()
			$WinEnd.ganhou()
			await get_tree().create_timer(5.0).timeout
			atribuir_medalaha()
			get_tree().change_scene_to_file("res://scenes/levels.tscn")
			return

		# Troca de tabuleiro:
		# No Difícil (3): troca a cada acerto
		# No Médio (2): troca apenas se tiver atingido o tempo de 12s (troca_tabuleiro_pendente)
		if Global.Dificuldade == 3:
			montarTabuleiro()
			await get_tree().create_timer(0.3).timeout
		elif Global.Dificuldade == 2 and troca_tabuleiro_pendente:
			montarTabuleiro()
			troca_tabuleiro_pendente = false
			$ChangeSetup.start(12.0)
			await get_tree().create_timer(0.3).timeout

		# Agenda a próxima pergunta com uma pequena pausa natural
		$TimerQuestion.start(0.8)

	else:
		# === RESPOSTA ERRADA ===
		$Pontos.resposta_errada()
		$Errou.play()

		# Direção do impacto na "parede"
		var base_pos = Vector2(380, 320)
		var offset_impacto = Vector2.ZERO
		match index:
			0: # Cima
				offset_impacto = Vector2(0, -85)
			1: # Direita
				offset_impacto = Vector2(85, 0)
			2: # Baixo
				offset_impacto = Vector2(0, 85)
			3: # Esquerda
				offset_impacto = Vector2(-85, 0)

		# Efeito visual: avança rápido na direção errada ("bate na parede") e ricocheteia elástico de volta ao centro
		var tween_erro = create_tween()
		tween_erro.tween_property(label, "position", base_pos + offset_impacto, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween_erro.parallel().tween_property(label, "modulate", Color(1.0, 0.35, 0.35, 1.0), 0.12)
		tween_erro.tween_property(label, "position", base_pos, 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween_erro.parallel().tween_property(label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)

		# Pausa suave e toca a pronúncia da sílaba clicada (estímulo fonético educativo)
		await get_tree().create_timer(0.2).timeout
		$Silaba_Sound.stream = Global.array_dicionario[arraySilabas[index]].som
		$Silaba_Sound.play()

		# Aguarda o áudio terminar antes de permitir nova tentativa
		await get_tree().create_timer(1.0).timeout
		pode_responder = true


# ─────────────────────────────────────────
# MONTAGEM DO TABULEIRO
# ─────────────────────────────────────────

func montarTabuleiro() -> void:
	formularArray()
	definirImagens()
	fila_perguntas_locais.clear()
	ultima_silaba_idx_local = -1


func formularArray() -> void:
	arraySilabas.clear()

	# Recarrega o pool de sílabas se houver menos de 4 disponíveis
	if pool_dicionario.size() < 4:
		var novo_pool: Array = []
		for i in range(Global.array_dicionario.size()):
			if not pool_dicionario.has(i):
				novo_pool.append(i)
		novo_pool.shuffle()
		pool_dicionario.append_array(novo_pool)

	# Retira 4 sílabas únicas do pool para compor os 4 quadrantes
	for i in range(4):
		arraySilabas.append(pool_dicionario.pop_front())


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


# ─────────────────────────────────────────
# TIMERS E GERAÇÃO DE PERGUNTAS
# ─────────────────────────────────────────

func _on_change_setup_timeout() -> void:
	# Apenas a Dificuldade 2 (Médio) utiliza troca periódica de tabuleiro
	if Global.Dificuldade != 2 or acertos >= 10:
		return

	# Marca a troca como pendente para acontecer suavemente após o acerto do aluno
	troca_tabuleiro_pendente = true


func _on_question_timeout() -> void:
	if aguardando_resposta or acertos >= 10:
		return

	# Garante que não haja Label duplicada
	var label_antiga = get_node_or_null("LabelSilaba")
	if label_antiga:
		label_antiga.queue_free()

	$Pontos.nova_pergunta()
	aguardando_resposta = true

	# Se a fila de perguntas locais estiver vazia, recarrega com as 4 opções embaralhadas
	if fila_perguntas_locais.is_empty():
		var opcoes: Array = [0, 1, 2, 3]
		opcoes.shuffle()
		# Evita que a primeira da nova rodada seja idêntica à última perguntada
		if opcoes[0] == ultima_silaba_idx_local and opcoes.size() > 1:
			var temp = opcoes[0]
			opcoes[0] = opcoes[1]
			opcoes[1] = temp
		fila_perguntas_locais = opcoes

	var idx_local: int = fila_perguntas_locais.pop_front()
	ultima_silaba_idx_local = idx_local
	arrayNum_atual = arraySilabas[idx_local]

	var label = Label.new()
	label.text = silabaDri[idx_local]
	label.position = Vector2(380, 320)
	label.size = Vector2(219, 137)
	label.pivot_offset = Vector2(109.5, 68.5)
	label.scale = Vector2(0.1, 0.1)
	label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	label.add_theme_font_size_override("font_size", 100)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.name = "LabelSilaba"
	add_child(label)

	# Efeito visual de entrada: aparece no centro aumentando com efeito elástico (pop-in)
	var tween_in = create_tween().set_parallel(true)
	tween_in.tween_property(label, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_in.tween_property(label, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# Toca o som da sílaba da pergunta sorteada
	var som_path = Global.array_dicionario[arrayNum_atual].som
	$Silaba_Sound.stream = som_path
	$Silaba_Sound.play()

	pode_responder = true


# ─────────────────────────────────────────
# MEDALHAS
# ─────────────────────────────────────────

func atribuir_medalaha() -> void:
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


# ─────────────────────────────────────────
# INTERFACE DO USUÁRIO (HUD)
# ─────────────────────────────────────────

func atualizar_etapas() -> void:
	if has_node("Etapas"):
		var etapa_atual = min(acertos + 1, TOTAL_ETAPAS)
		$Etapas.text = "Etapa: %d/%d" % [etapa_atual, TOTAL_ETAPAS]

