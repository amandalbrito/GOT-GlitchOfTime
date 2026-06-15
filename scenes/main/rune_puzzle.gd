extends Control

@onready var cursor = $PuzzleWindowG/Bar/Cursor
@onready var zone = $PuzzleWindowG/SuccessZone
@onready var status_label = $PuzzleWindowG/StatusLabel
@onready var bar = $PuzzleWindowG/Bar

var is_open := false
var can_close := false
var current_rune := 0
var direction := 1
var speed := 220.0
var completed := false


func _ready():

	visible = false
	is_open = false


func open_puzzle(id):

	# evita abrir duas vezes
	if is_open:
		return

	current_rune = id

	visible = true
	is_open = true
	completed = false
	can_close = false

	status_label.text = "Aperte SHIFT ou [L2] quando o indicador alcancar o ponto verde"

	# reseta cursor
	cursor.position.x = 0
	direction = 1

	# randomiza posição da área verde
	var min_x = 40
	var max_x = (
		bar.size.x
		- zone.size.x
		- 40
	)

	zone.position.x = randi_range(
		min_x,
		max_x
	)

	# evita o ENTER fechar instantaneamente
	await get_tree().create_timer(0.4).timeout

	can_close = true


func _process(delta):

	# se não estiver aberto → ignora tudo
	if !is_open:
		return

	move_cursor(delta)

	# SHIFT = timing
	if (
		!completed
		and Input.is_action_just_pressed(
			"rune_action"
		)
	):

		check_hit()

	# ENTER fecha depois de concluir
	if (
		completed
		and can_close
		and Input.is_action_just_pressed(
			"ui_accept"
		)
	):

		close_puzzle()


func move_cursor(delta):

	cursor.position.x += speed * direction * delta

	var limit = (
		bar.size.x
		- cursor.size.x
	)

	# direita
	if cursor.position.x >= limit:

		cursor.position.x = limit
		direction = -1

	# esquerda
	elif cursor.position.x <= 0:

		cursor.position.x = 0
		direction = 1


func check_hit():

	var cursor_rect = (
		cursor.get_global_rect()
	)

	var zone_rect = (
		zone.get_global_rect()
	)

	# acertou timing
	if zone_rect.intersects(
		cursor_rect
	):

		status_label.text = (
			"RUNA ATIVADA"
		)

		completed = true

		var fase = (
			get_tree()
			.current_scene
		)

		fase.guardian_runes += 1

		print(
			"RUNAS:",
			fase.guardian_runes,
			"/3"
		)

		fase.check_lighthouse()

		print("ACERTOU")

		await get_tree().create_timer(
			0.8
		).timeout

		close_puzzle()

	# errou
	else:

		status_label.text = (
			"ERROU"
		)

		print("ERROU")

func close_puzzle():

	visible = false
	is_open = false
	can_close = false
	completed = false
