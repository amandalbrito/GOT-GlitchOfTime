extends CanvasLayer

@onready var visor = $PuzzleRelogio/VisorTemperatura

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

var valores = [0, 0, 0, 0, 0]

const TEMPERATURA_BASE = -42

const TEMPERATURA_MINIMA = 50
const TEMPERATURA_MAXIMA = 60

const MODIFICADORES = [3, -7, 12, 5, -10]

@onready var lago_congelado = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/Congelado"
@onready var lago_descongelado = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/Descongelado"
@onready var collision_lago = $"../../../../DownView/SubViewportDown/PastWorld/LagoCongelado/StaticBody2D/CollisionShape2D"

@onready var mensagem = get_node_or_null("BackGroundText")
@onready var texto = get_node_or_null("BackGroundText/CommandCientista")
@onready var timer = get_node_or_null("BackGroundText/CommandCientista/Timer")

func _ready():

	hide()

	lago_congelado.visible = true
	lago_descongelado.visible = false
	collision_lago.disabled = false

	atualizar_ui()
	
	if mensagem:
		mensagem.visible = false

func abrir_popup(painel):

	painel_atual = painel

	show()
	
	mostrar_sequencia()

func fechar_popup():

	hide()

func _process(_delta):

	if not visible:
		return

	# TROCAR LINHA

	if Input.is_action_just_pressed("puzzle_relogio_right"):

		linha_selecionada += 1

		if linha_selecionada > 4:
			linha_selecionada = 0

		atualizar_ui()

	if Input.is_action_just_pressed("puzzle_relogio_left"):

		linha_selecionada -= 1

		if linha_selecionada < 0:
			linha_selecionada = 4

		atualizar_ui()

	# DIMINUIR

	if Input.is_action_just_pressed("puzzle_relogio_down"):

		valores[linha_selecionada] -= MODIFICADORES[linha_selecionada]

		atualizar_ui()

	# AUMENTAR

	if Input.is_action_just_pressed("puzzle_relogio_up"):

		valores[linha_selecionada] += MODIFICADORES[linha_selecionada]

		atualizar_ui()

	# FECHAR

	if Input.is_action_just_pressed("puzzle_relogio_cancel"):

		fechar_popup()

	# VERIFICAR TEMPERATURA

	var temperatura_final = calcular_temperatura()

	if (
		temperatura_final >= TEMPERATURA_MINIMA
		and temperatura_final <= TEMPERATURA_MAXIMA
		and not puzzle_resolvido
	):

		resolver_puzzle()

func calcular_temperatura():

	var temperatura_total = TEMPERATURA_BASE

	for valor in valores:

		temperatura_total += valor

	return temperatura_total

func atualizar_ui():

	var temperatura_total = calcular_temperatura()

	for i in range(linhas.size()):

		linhas[i].text = "█"

		if i == linha_selecionada:

			linhas[i].modulate = Color(1, 1, 0)
			linhas[i].scale = Vector2(1.5, 1.5)

		else:

			linhas[i].modulate = Color(1, 1, 1)
			linhas[i].scale = Vector2(1, 1)

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

func mostrar_mensagem(msg: String, tempo: float = 5.0):
	if not texto or not mensagem or not timer:
		return

	texto.text = msg
	mensagem.visible = true
	timer.start(tempo)

func mostrar_sequencia():
	mostrar_mensagem("Navegue entre os pontos para ajustar a temperatura para derreter o lago e ajudar Ravi", 3)

	await get_tree().create_timer(3.0).timeout

	mostrar_mensagem("F e H: navega entre os pontos\nT e G: ajusta a temperatura", 3)

func resolver_puzzle():

	puzzle_resolvido = true

	print("PUZZLE RESOLVIDO")

	lago_congelado.visible = false
	lago_descongelado.visible = true
	collision_lago.disabled = true

	if painel_atual:

		painel_atual.liberar_passagem()

	await get_tree().create_timer(5.0).timeout

	fechar_popup()


func _on_timer_timeout() -> void:
	if mensagem:
		mensagem.visible = false
