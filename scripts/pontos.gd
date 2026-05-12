extends Label

var pontos: float = 200.0

# CONFIGURAÇÕES
var tempo_fase := 240.0 # 4 minutos
var perdendo_pontos := true

# Quanto perde por segundo
var perda_por_segundo := 200.0 / tempo_fase

func _ready() -> void:
	if Global.Dificuldade == 1:
		pontos = 250.0
	
	if Global.Dificuldade == 2:
		pontos = 220.0
	
	if Global.Dificuldade == 3:
		pontos = 180.0
		perda_por_segundo = perda_por_segundo*2


func _process(delta: float) -> void:
	# Só perde pontos enquanto a pergunta estiver ativa
	if perdendo_pontos:
		pontos -= perda_por_segundo * delta
	
		# Impede pontos negativos
		pontos = max(pontos, 0)
	
	atualizar_ui()


func resposta_correta():
	# Para de perder pontos até a próxima pergunta
	perdendo_pontos = false


func resposta_errada():
	# Perde 5 pontos instantaneamente
	pontos -= 5
	
	# Impede negativo
	pontos = max(pontos, 0)


func nova_pergunta():
	# Volta a perder pontos
	perdendo_pontos = true


func atualizar_ui():
	# Exemplo usando uma Label
	self.text = str("%.2f" % pontos)


func qtdPontos():
	return pontos
