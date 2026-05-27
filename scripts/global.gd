extends Node

# Dados para plataforma
var Score : int = 0
var erros : int = 0
var TempoDeJogo_Min : int = 0
var TempoDeJogo_Sec : int = 0
var JogoConcluido : bool = false
var Dificuldade = 1

# Permite que a intro toque só uma vez
var Intro_tocar : bool = true

var medal = [null, null, null]

# Array principal de dicionários com todos os dados locais
var array_dicionario = [
	# 0
	{
		"palavra": "AVIAO",
		"silaba": "A",
		"complemento_silaba": "_ VIAO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/A_Aviao_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/A_Aviao_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/A_Aviao_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/A_Aviao_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/a.ogg"),
	},
	# 1
	{
		"palavra": "BANANA",
		"silaba": "BA",
		"complemento_silaba": "_ _NANA",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ba_Banana_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ba_Banana_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ba_Banana_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ba_Banana_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ba.ogg"),
	},
	# 2
	{
		"palavra": "CACHORRO",
		"silaba": "CA",
		"complemento_silaba": "_ _CHORRO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ca_Cachorro_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ca_Cachorro_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ca_Cachorro_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ca_Cachorro_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ca.ogg"),
	},
	# 3
	{
		"palavra": "DADO",
		"silaba": "DA",
		"complemento_silaba": "_ _DO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Da_Dado_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Da_Dado_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Da_Dado_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Da_Dado_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/da.ogg"),
	},
	# 4
	{
		"palavra": "FACA",
		"silaba": "FA",
		"complemento_silaba": "_ _CA",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Fa_Faca_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Fa_Faca_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Fa_Faca_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Fa_Faca_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/fa.ogg"),
	},
	# 5
	{
		"palavra": "GATO",
		"silaba": "GA",
		"complemento_silaba": "_ _TO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ga_Gato_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ga_Gato_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ga_Gato_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ga_Gato_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ga.ogg"),
	},
	# 6
	{
		"palavra": "JACARE",
		"silaba": "JA",
		"complemento_silaba": "_ _CARE",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ja_Jacare_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ja_Jacare_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ja_Jacare_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ja_Jacare_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ja.ogg"),
	},
	# 7
	{
		"palavra": "LAPIS",
		"silaba": "LA",
		"complemento_silaba": "_ _PIS",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/La_Lapis_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/La_Lapis_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/La_Lapis_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/La_Lapis_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/la.ogg"),
	},
	# 8
	{
		"palavra": "MACACO",
		"silaba": "MA",
		"complemento_silaba": "_ _CACO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ma_Macaco_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ma_Macaco_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ma_Macaco_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ma_Macaco_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ma.ogg"),
	},
	# 9
	{
		"palavra": "NAVIO",
		"silaba": "NA",
		"complemento_silaba": "_ _VIO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Na_Navio_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Na_Navio_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Na_Navio_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Na_Navio_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/na.ogg"),
	},
	# 10
	{
		"palavra": "PATO",
		"silaba": "PA",
		"complemento_silaba": "_ _TO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Pa_Pato_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Pa_Pato_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Pa_Pato_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Pa_Pato_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/pa.ogg"),
	},
	# 11
	{
		"palavra": "QUATI",
		"silaba": "QUA",
		"complemento_silaba": "_ _TI",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Qua_Quati_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Qua_Quati_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Qua_Quati_Imagem_1.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/qua.ogg"),
	},
	# 12
	{
		"palavra": "RATO",
		"silaba": "RA",
		"complemento_silaba": "_ _TO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ra_Rato_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ra_Rato_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ra_Rato_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ra_Rato_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ra.ogg"),
	},
	# 13
	{
		"palavra": "SAPO",
		"silaba": "SA",
		"complemento_silaba": "_ _PO",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Sa_Sapo_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Sa_Sapo_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Sa_Sapo_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Sa_Sapo_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/sa.ogg"),
	},
	# 14
	{
		"palavra": "TATU",
		"silaba": "TA",
		"complemento_silaba": "_ _TU",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Ta_Tatu_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ta_Tatu_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Ta_Tatu_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Ta_Tatu_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/ta.ogg"),
	},
	# 15
	{
		"palavra": "VACA",
		"silaba": "VA",
		"complemento_silaba": "_ _CA",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Va_Vaca_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Va_Vaca_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Va_Vaca_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Va_Vaca_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/va.ogg"),
	},
	# 16
	{
		"palavra": "XADREZ",
		"silaba": "XA",
		"complemento_silaba": "_ _DREZ",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Xa_Xadrez_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Xa_Xadrez_Foto_2.png"),
			preload("res://assets/NinoEdu/Imagens/Xa_Xadrez_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Xa_Xadrez_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/xa.ogg"),
	},
	# 17
	{
		"palavra": "ZABUMBA",
		"silaba": "ZA",
		"complemento_silaba": "_ _BUMBA",
		"imagens": [
			preload("res://assets/NinoEdu/Imagens/Za_Zabumba_Foto_1.png"),
			preload("res://assets/NinoEdu/Imagens/Za_Zabumba_Imagem_1.png"),
			preload("res://assets/NinoEdu/Imagens/Za_Zabumba_Imagem_2.png"),
		],
		"som": preload("res://assets/NinoEdu/Audios/za.ogg"),
	},
]
