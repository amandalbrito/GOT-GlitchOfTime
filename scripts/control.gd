extends CanvasLayer

@onready var puzzle_root = $PuzzleRelogio

@onready var visor = (
	$PuzzleRelogio/VisorTemperatura
)

@onready var linhas = [
	$PuzzleRelogio/Slider1,
	$PuzzleRelogio/Slider2,
	$PuzzleRelogio/Slider3,
	$PuzzleRelogio/Slider4,
	$PuzzleRelogio/Slider5
]

var painel_atual = null
var puzzle_resolvido = false
var linha_selecionada = 0
var valores = [0,0,0,0,0]
var pode_fechar = false
const TEMPERATURA_BASE = -42
const TEMPERATURA_MINIMA = 50
const TEMPERATURA_MAXIMA = 60

const MODIFICADORES = [
	3,
	-7,
	12,
	5,
	-10
]

@onready var lago_congelado = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/Congelado"

@onready var lago_descongelado = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/Descongelado"

@onready var collision_lago = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/StaticBody2D/CollisionShape2D"

@onready var mensagem = $BackGroundText

@onready var texto = (
	$BackGroundText/CommandCientista
)

@onready var timer = (
	$BackGroundText/CommandCientista/Timer
)


func _ready():

	print("VISOR:", visor)

	# ESCONDE APENAS O PUZZLE
	puzzle_root.hide()

	mensagem.visible = false

	lago_congelado.visible = true
	lago_descongelado.visible = false
	collision_lago.disabled = false

	atualizar_ui()


func abrir_popup(painel):

	painel_atual = painel

	puzzle_root.show()

	atualizar_ui()

	mostrar_sequencia()

	# evita fechar instantaneamente
	pode_fechar = false

	await get_tree().create_timer(
		0.2
	).timeout

	pode_fechar = true


func fechar_popup():

	puzzle_root.hide()


func _process(_delta):

	if not puzzle_root.visible:
		return


	# FECHAR COM E
	if (
		pode_fechar
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):

		fechar_popup()
		return


	# T = aumenta temperatura
	if Input.is_action_just_pressed(
		"puzzle_relagio_left"
	):

		for i in range(
			valores.size()
		):
			valores[i] -= 1

		atualizar_ui()


	# G = diminui temperatura
	if Input.is_action_just_pressed(
		"puzzle_relagio_right"
	):

		for i in range(
			valores.size()
		):
			valores[i] += 1

		atualizar_ui()


	# verifica temperatura
	var temperatura_final = (
		calcular_temperatura()
	)

	if (
		temperatura_final >= TEMPERATURA_MINIMA
		and temperatura_final <= TEMPERATURA_MAXIMA
		and not puzzle_resolvido
	):

		resolver_puzzle()


func calcular_temperatura():

	var temperatura_total = (
		TEMPERATURA_BASE
	)

	for i in range(
		valores.size()
	):

		temperatura_total += (
			valores[i]
			* MODIFICADORES[i]
		)

	return temperatura_total


func atualizar_ui():

	var temperatura_total = (
		calcular_temperatura()
	)

	for i in range(
		linhas.size()
	):

		linhas[i].text = "█"

		if i == linha_selecionada:

			linhas[i].modulate = (
				Color.YELLOW
			)

			linhas[i].scale = (
				Vector2(1.5,1.5)
			)

		else:

			linhas[i].modulate = (
				Color.WHITE
			)

			linhas[i].scale = (
				Vector2.ONE
			)

	# VISOR

	visor.text = str(int(temperatura_total)) + "°"
	
	Global.temperatura = temperatura_total
	
	# COR DO VISOR
	if temperatura_total < 0:
		visor.modulate = Color(0.4, 0.7, 1.0)
	elif temperatura_total < 18:
		visor.modulate = Color(1.0, 0.8, 0.2)
	elif temperatura_total <= 35:
		visor.modulate = Color(0.3, 1.0, 0.5)
	elif temperatura_total <= 60:
		visor.modulate = Color(0.84, 0.227, 0.237, 1.0)
	else:
		visor.modulate = Color(0.66, 0.073, 0.073, 1.0)


func mostrar_mensagem(
	msg: String,
	tempo: float = 5.0
):

	texto.text = msg
	mensagem.visible = true
	timer.start(tempo)


func mostrar_sequencia():

	mostrar_mensagem(
		"Navegue entre os pontos para ajustar a temperatura.",
		3
	)

	await get_tree().create_timer(
		3
	).timeout

	mostrar_mensagem(
		"F/H navega\nT/G ajusta",
		3
	)


func resolver_puzzle():

	puzzle_resolvido = true

	Global.add_instability(-5)

	print(
		"PUZZLE RESOLVIDO"
	)

	lago_congelado.visible = false
	lago_descongelado.visible = true
	collision_lago.disabled = true

	if painel_atual:
		painel_atual.liberar_passagem()

	await get_tree().create_timer(
		5
	).timeout

	fechar_popup()


func _on_timer_timeout():

	mensagem.visible = false
