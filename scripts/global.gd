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
