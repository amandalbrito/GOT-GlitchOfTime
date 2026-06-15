extends Node2D

@export var allow_crossed_wires = true
@export var only_cardinals = false

signal puzzle_completed

const Circle = preload("res://scenes/fase1/circle.gd")

var circles: Array[Circle] = []
var correct_sequence = Line2D.new()
var is_correct = false
var correct_color = null
var error_message = ""

# LAYOUT
var spacing = 85
var radius = 24

# posição das bolinhas
var side_offset_x = 70
var side_offset_y = 120

var currently_selected = null
var default_color = Color.GREEN

var main_line = Line2D.new()
var solved_color = Color.PURPLE

var show_hint = false

var answer_texture = preload(
	"res://scenes/fase1/answer_paper.png"
)

func _ready() -> void:

	if not Global.has_setup:
		Global.allow_crossed_wires = allow_crossed_wires
		Global.only_cardinals = only_cardinals
		Global.has_setup = true

	add_child(main_line)

	# cria os círculos
	for y in range(3):
		for x in range(3):

			circles.append(
				Circle.new(
					Vector2(
						x * spacing + side_offset_x,
						y * spacing + side_offset_y
					),
					radius,
					default_color
				)
			)

	# sequência correta
	for i in [0, 1, 4, 2, 5, 8, 7, 3, 6]:
		correct_sequence.add_point(circles[i].pos)

	queue_redraw()

	print("PIN CODE RODANDO")

	# posição da janela
	position = Vector2(320, -20)


func _process(_delta: float) -> void:

	allow_crossed_wires = Global.allow_crossed_wires
	only_cardinals = Global.only_cardinals

	if visible:
		queue_redraw()


func reset_puzzle():

	main_line.clear_points()

	currently_selected = null
	is_correct = false
	correct_color = null
	show_hint = false

	for circle in circles:
		circle.color = default_color

	queue_redraw()


func is_connection_valid(start: Vector2, end: Vector2) -> bool:

	if not allow_crossed_wires:

		for i in range(main_line.points.size() - 1):

			if Geometry2D.segment_intersects_segment(
				main_line.get_point_position(i),
				main_line.get_point_position(i + 1),
				start,
				end
			) != null and main_line.get_point_position(i + 1) != start:

				return false

	if only_cardinals and not (
		start.x == end.x or start.y == end.y
	):
		return false

	for circle in circles:

		if circle.pos == start or circle.pos == end:
			continue

		if main_line.points.has(end):
			return false

		if Geometry2D.segment_intersects_circle(
			start,
			end,
			circle.pos,
			circle.radius
		) >= 0:
			return false

	return true


func _input(event: InputEvent) -> void:

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	# abrir/fechar dica
	if event is InputEventKey and event.pressed:

		if event.keycode == KEY_T:

			show_hint = !show_hint
			queue_redraw()

	# conectar bolinhas
	if Input.is_action_pressed("select"):
		for circle in circles:

			if Geometry2D.is_point_in_circle(
				get_local_mouse_position(),
				circle.pos,
				radius
			):

				if currently_selected != null:
					currently_selected.color = default_color

				if currently_selected == null or is_connection_valid(
					currently_selected.pos,
					circle.pos
				):

					main_line.add_point(circle.pos)

					currently_selected = circle
					circle.color = Color.BLACK

					check_pattern()

					queue_redraw()


func blink_color():

	for i in range(10):

		correct_color = solved_color
		queue_redraw()

		await get_tree().create_timer(0.2).timeout

		correct_color = null
		queue_redraw()

		await get_tree().create_timer(0.2).timeout

func wrong_pattern():

	error_message = (
		"Padrao incorreto."
	)

	queue_redraw()

	await get_tree().create_timer(
		1.5
	).timeout

	error_message = ""

	reset_puzzle()

	queue_redraw()

func _draw():

	# fundo
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(500, 350)),
		Color.BLACK
	)

	# TEXTO
	draw_string(
		ThemeDB.fallback_font,
		Vector2(20, 40),
		"Se nao quiser tanto desafio, pressione T",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		18,
		Color.WHITE
	)

	draw_string(
		ThemeDB.fallback_font,
		Vector2(20, 65),
		"Para fechar, pressione E novamente",
		HORIZONTAL_ALIGNMENT_LEFT,
		400,
		18,
		Color.WHITE
	)
	
		# mensagem de erro
	if error_message != "":

		draw_string(
			ThemeDB.fallback_font,
			Vector2(145, 340),
			error_message,
			HORIZONTAL_ALIGNMENT_LEFT,
			180,
			14,
			Color(1, 0.45, 0.45)
		)

	# bolinhas
	for circle in circles:

		if correct_color == null:

			draw_circle(
				circle.pos,
				circle.radius,
				circle.color
			)

		else:

			draw_circle(
				circle.pos,
				circle.radius,
				correct_color
			)

	# linhas
	if main_line.points.size() > 1:

		for i in range(main_line.points.size() - 1):

			draw_line(
				main_line.points[i],
				main_line.points[i + 1],
				Color.WHITE,
				6
			)

	# senha
	if show_hint:

		draw_texture_rect(
			answer_texture,
			Rect2(
				Vector2(300, 110),
				Vector2(170, 100)
			),
			false
		)
func check_pattern():

	if is_correct:
		return

	if (
		main_line.points.size()
		!= correct_sequence.points.size()
	):
		return

	if (
		main_line.points
		== correct_sequence.points
	):

		is_correct = true

		puzzle_completed.emit()

		blink_color()

	else:

		wrong_pattern()
