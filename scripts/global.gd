extends Node

#Node HTTPRequest
var JsonRequest = HTTPRequest.new()
var ImagemRequest = HTTPRequest.new()
var AudioRequest = HTTPRequest.new()

# Recebe as requisicoes
#var array_dicionario: Array
var array_dicionario_imagens: Array
var texturas : Array
var audio

#posicao no array de requisicoes
var index = 0
var cont_img = 0

#array com dados apos as requisicoes
var array_silabas: Array
var array_imagens: Array


var medal = [null, null, null]


# cria dicionario
var dicionario : Dictionary = {
	"palavra" : "",
	"silaba" :  "",
	"complemento_silaba" : "",
	"imagens" : null,
	"som" : null
}

# Dados para plataforma
var Score : int = 0
var erros : int = 0
var TempoDeJogo_Min : int = 0
var TempoDeJogo_Sec : int = 0
var JogoConcluido : bool = false
var Dificuldade = 1

#Permite que a intro toque só uma vez
var Intro_tocar : bool = true


var array_dicionario = [
	{
		"palavra": "AVIAO",
		"silaba": "A",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/A_Aviao_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/A_Aviao_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/A_Aviao_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/A_Aviao_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/a.ogg",
		"complemento_silaba": "_ VIAO"
	},

	{
		"palavra": "BANANA",
		"silaba": "BA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ba_Banana_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ba_Banana_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ba_Banana_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ba_Banana_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ba.ogg",
		"complemento_silaba": "_ _NANA"
	},

	{
		"palavra": "CACHORRO",
		"silaba": "CA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ca_Cachorro_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ca_Cachorro_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ca_Cachorro_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ca_Cachorro_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ca.ogg",
		"complemento_silaba": "_ _CHORRO"
	},

	{
		"palavra": "DADO",
		"silaba": "DA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Da_Dado_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Da_Dado_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Da_Dado_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Da_Dado_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/da.ogg",
		"complemento_silaba": "_ _DO"
	},

	{
		"palavra": "FACA",
		"silaba": "FA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Fa_Faca_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Fa_Faca_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Fa_Faca_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Fa_Faca_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/fa.ogg",
		"complemento_silaba": "_ _CA"
	},

	{
		"palavra": "GATO",
		"silaba": "GA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ga_Gato_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ga_Gato_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ga_Gato_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ga_Gato_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ga.ogg",
		"complemento_silaba": "_ _TO"
	},

	{
		"palavra": "JACARE",
		"silaba": "JA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ja_Jacare_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ja_Jacare_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ja_Jacare_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ja_Jacare_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ja.ogg",
		"complemento_silaba": "_ _CARE"
	},

	{
		"palavra": "LAPIS",
		"silaba": "LA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/La_Lapis_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/La_Lapis_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/La_Lapis_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/La_Lapis_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/la.ogg",
		"complemento_silaba": "_ _PIS"
	},

	{
		"palavra": "MACACO",
		"silaba": "MA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ma_Macaco_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ma_Macaco_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ma_Macaco_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ma_Macaco_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ma.ogg",
		"complemento_silaba": "_ _CACO"
	},

	{
		"palavra": "NAVIO",
		"silaba": "NA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Na_Navio_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Na_Navio_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Na_Navio_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Na_Navio_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/na.ogg",
		"complemento_silaba": "_ _VIO"
	},

	{
		"palavra": "PATO",
		"silaba": "PA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Pa_Pato_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Pa_Pato_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Pa_Pato_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Pa_Pato_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/pa.ogg",
		"complemento_silaba": "_ _TO"
	},

	{
		"palavra": "QUATI",
		"silaba": "QUA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Qua_Quati_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Qua_Quati_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Qua_Quati_Imagem_1.png" }
		],
		"som": "res://assets/NinoEdu/Audios/qua.ogg",
		"complemento_silaba": "_ _TI"
	},

	{
		"palavra": "RATO",
		"silaba": "RA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ra_Rato_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ra_Rato_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ra_Rato_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ra_Rato_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ra.ogg",
		"complemento_silaba": "_ _TO"
	},

	{
		"palavra": "SAPO",
		"silaba": "SA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Sa_Sapo_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Sa_Sapo_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Sa_Sapo_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Sa_Sapo_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/sa.ogg",
		"complemento_silaba": "_ _PO"
	},

	{
		"palavra": "TATU",
		"silaba": "TA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Ta_Tatu_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ta_Tatu_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ta_Tatu_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Ta_Tatu_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/ta.ogg",
		"complemento_silaba": "_ _TU"
	},

	{
		"palavra": "VACA",
		"silaba": "VA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Va_Vaca_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Va_Vaca_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Va_Vaca_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Va_Vaca_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/va.ogg",
		"complemento_silaba": "_ _CA"
	},

	{
		"palavra": "XADREZ",
		"silaba": "XA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Xa_Xadrez_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Xa_Xadrez_Foto_2.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Xa_Xadrez_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Xa_Xadrez_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/xa.ogg",
		"complemento_silaba": "_ _DREZ"
	},

	{
		"palavra": "ZABUMBA",
		"silaba": "ZA",
		"imagens": [
			{ "imagem": "res://assets/NinoEdu/Imagens/Za_Zabumba_Foto_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Za_Zabumba_Imagem_1.png" },
			{ "imagem": "res://assets/NinoEdu/Imagens/Za_Zabumba_Imagem_2.png" }
		],
		"som": "res://assets/NinoEdu/Audios/za.ogg",
		"complemento_silaba": "_ _BUMBA"
	}
]


func _ready() -> void:
	add_child(JsonRequest)
	add_child(ImagemRequest)
	add_child(AudioRequest)
	# Conecta o sinal de conclusão da requisição
	JsonRequest.request_completed.connect(_on_json_request_completed)
	ImagemRequest.request_completed.connect(_on_imagem_request_completed)
	AudioRequest.request_completed.connect(_on_audio_request_completed)
	
	var url = "http://localhost:8080/api/recursos/silabas?vogal=A&limite=18&tipoColorir=NAO_COLORIR&quantImagens=4"
	var headers = [
		"Content-Type: application/json",
	]
	JsonRequest.request(url,
		headers,
		HTTPClient.METHOD_GET)


func _on_json_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json_string = body.get_string_from_utf8()
	
	var json = JSON.parse_string(json_string)
	
	array_dicionario = json
	
	#request_imagem()


#func request_imagem():
	#if index == array_dicionario.size():
		#return
	##request imagem
	#array_dicionario_imagens = array_dicionario[index].imagens
	#if cont_img < array_dicionario_imagens.size():
		#ImagemRequest.request(array_dicionario_imagens[cont_img].imagem)
		#cont_img += 1 


func _on_imagem_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var image = Image.new()
	var err = image.load_png_from_buffer(body)
	var texture = ImageTexture.create_from_image(image)
	texturas.append(texture)
	
	#if cont_img < array_dicionario_imagens.size():
		##request_imagem()
	#else:
		#AudioRequest.request(array_dicionario[index].som)

func _on_audio_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	audio = AudioStreamOggVorbis.load_from_buffer(body)
	cria_dicionario()


func cria_dicionario() -> void:
	dicionario = {
		"palavra" : array_dicionario[index].palavra,
		"silaba" :  array_dicionario[index].silaba,
		"complemento_silaba" : array_dicionario[index].complemento_silaba,
		"imagens" : texturas.duplicate(),
		"som" : audio
	}
	array_silabas.append(dicionario)
	
	index += 1
	
	print(index)
	
	cont_img = 0
	texturas.clear()
	#request_imagem()


func embaralhar():
	array_silabas.shuffle()
	array_imagens = array_silabas[0].imagens
	array_imagens.shuffle()
