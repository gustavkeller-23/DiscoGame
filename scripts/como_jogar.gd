extends Node2D

signal yellowButton
signal blueButton
signal redButton
signal greenButton

var arraySilabas = [0,1,2,3]
var silabaDri = []
var pode_responder = true

var silaba_ativa_idx_direcao: int = -1  # índice 0-3 (qual direção é a correta)
var aguardando_resposta: bool = false


var acertos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	montarTabuleiro()
	await get_tree().create_timer(3).timeout
	
	$Label.text = silabaDri[0]
	$Seta.play("toTop")
	if Input.is_action_just_pressed("top_button"):
		_acerto()
		Parte2()



func Parte2():
	await get_tree().create_timer(3).timeout
	$Label.text = silabaDri[2]
	$Seta.play("toBot")
	if Input.is_action_just_pressed("bottom_button"):
		_acerto()


func _process(delta: float) -> void:
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
	
	if acertos == 2:
		acertos = acertos + 1
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://scenes/start.tscn")


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


func definirImagens():
	var imagens1 = Global.array_silabas[arraySilabas[0]].imagens
	var imagens2 = Global.array_silabas[arraySilabas[1]].imagens
	var imagens3 = Global.array_silabas[arraySilabas[2]].imagens
	var imagens4 = Global.array_silabas[arraySilabas[3]].imagens
	
	silabaDri.clear()
	
	silabaDri.append(Global.array_silabas[arraySilabas[0]].silaba)
	silabaDri.append(Global.array_silabas[arraySilabas[1]].silaba)
	silabaDri.append(Global.array_silabas[arraySilabas[2]].silaba)
	silabaDri.append(Global.array_silabas[arraySilabas[3]].silaba)
	
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
	$Silaba_Sound.stream = Global.array_silabas[arraySilabas[index]].som
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
