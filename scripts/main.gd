extends Node
 
signal yellowButton
signal blueButton
signal redButton
signal greenButton
 
# Índices sorteados do array_dicionario global (0 a 17)
var arraySilabas: Array = []
# Sílabas correspondentes aos 4 quadrantes [cima, direita, baixo, esquerda]
var silabaDri: Array = []
 
var pode_responder: bool = true
var aguardando_resposta: bool = false
var acertos: int = 0
 
# Índice do array_dicionario da sílaba que está sendo perguntada no momento
var arrayNum_atual: int = -1
 
 
func _ready() -> void:
	montarTabuleiro()
 
	$TimerQuestion.wait_time = 3
	if Global.Dificuldade == 1:
		$TimerQuestion.start()
 
	if Global.Dificuldade == 2:
		$TimerQuestion.start()
		$ChangeSetup.wait_time = 12
		$ChangeSetup.start()
 
	if Global.Dificuldade == 3:
		$TimerQuestion.start()
		$ChangeSetup.wait_time = 3.5
		$ChangeSetup.start()
 
 
func _process(_delta: float) -> void:
	if not pode_responder:
		return
 
	if Input.is_action_just_pressed("bottom_button"):
		processar_resposta(2)
	elif Input.is_action_just_pressed("top_button"):
		processar_resposta(0)
	elif Input.is_action_just_pressed("left_button"):
		processar_resposta(3)
	elif Input.is_action_just_pressed("right_button"):
		processar_resposta(1)
 
	if acertos == 10:
		acertos += 1
		$TimerQuestion.stop()
		$ChangeSetup.stop()
		$WinEnd.ganhou()
		await get_tree().create_timer(5).timeout
		atribuir_medalaha()
		get_tree().change_scene_to_file("res://scenes/levels.tscn")
 
 
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
	averiguarResposta(resposta)
	await get_tree().create_timer(0.5).timeout
	pode_responder = true
 
 
# ─────────────────────────────────────────
# MONTAGEM DO TABULEIRO
# ─────────────────────────────────────────
 
func montarTabuleiro() -> void:
	formularArray()
	definirImagens()
 
 
func formularArray() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
 
	arraySilabas.clear()
 
	# array_dicionario tem 18 entradas (índices 0 a 17)
	while arraySilabas.size() < 4:
		var numero = rng.randi_range(0, Global.array_dicionario.size() - 1)
		if not arraySilabas.has(numero):
			arraySilabas.append(numero)
 
 
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
# VERIFICAÇÃO DE RESPOSTA
# ─────────────────────────────────────────
 
func averiguarResposta(index: int) -> void:
	if not aguardando_resposta:
		return
 
	var label = get_node_or_null("LabelSilaba")
	if label == null:
		return
 
	# Verifica se a sílaba do quadrante pressionado bate com a sílaba exibida
	if silabaDri[index] == label.text:
		_acerto()
		$Pontos.resposta_correta()
	else:
		$Errou.play()
		$Pontos.resposta_errada()
 
	# Toca o som da sílaba do quadrante pressionado (usa load() local)
	await get_tree().create_timer(0.6).timeout
	var som_path = Global.array_dicionario[arraySilabas[index]].som
	$Silaba_Sound.stream = load(som_path)
	$Silaba_Sound.play()
 
 
func _acerto() -> void:
	$Acertou.play()
	acertos += 1
	var label = get_node_or_null("LabelSilaba")
	if label:
		label.queue_free()
		aguardando_resposta = false
 
 
# ─────────────────────────────────────────
# TIMERS
# ─────────────────────────────────────────
 
func _on_change_setup_timeout() -> void:
	var label = get_node_or_null("LabelSilaba")
	if label:
		# Ainda há uma sílaba esperando resposta; checa de novo em 0.5s
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
	if aguardando_resposta:
		return
 
	$Pontos.nova_pergunta()
	aguardando_resposta = true
 
	# Sorteia um dos 4 quadrantes ativos para ser a pergunta
	var idx_local = randi() % 4
	arrayNum_atual = arraySilabas[idx_local]
 
	var label = Label.new()
	label.text = silabaDri[idx_local]
	label.position = Vector2(380, 320)
	label.size = Vector2(219, 137)
	label.add_theme_font_size_override("font_size", 100)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.name = "LabelSilaba"
	add_child(label)
 
	# Toca o som da sílaba sorteada
	var som_path = Global.array_dicionario[arrayNum_atual].som
	$Silaba_Sound.stream = load(som_path)
	$Silaba_Sound.play()
 
 
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
