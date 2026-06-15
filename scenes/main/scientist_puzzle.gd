extends Node2D

signal puzzle_finished

@onready var left_blue = $PuzzleWindow/LeftBlue
@onready var left_red = $PuzzleWindow/LeftRed
@onready var left_yellow = $PuzzleWindow/LeftYellow

@onready var right1 = $PuzzleWindow/Right1
@onready var right2 = $PuzzleWindow/Right2
@onready var right3 = $PuzzleWindow/Right3

@onready var wire_blue = $WireBlue

@onready var wire_red = $WireRed

@onready var wire_yellow = $WireYellow


var current_terminal := 0
var is_open := false
var can_close := false

var dragging := false
var dragging_color := ""

var connected = {
	"blue": false,
	"red": false,
	"yellow": false
}

var layout = {}


func _ready():

	visible = false

	left_blue.pressed.connect(
		func():
			print("CLICOU AZUL")
			start_drag("blue")
	)

	left_red.pressed.connect(
		func():
			print("CLICOU RED")
			start_drag("red")
	)

	left_yellow.pressed.connect(
		func():
			print("CLICOU YELLOW")
			start_drag("yellow")
	)


func open_puzzle(id):

	if is_open:
		close_puzzle()
		return

	current_terminal = id

	randomize_layout()

	visible = true
	is_open = true

	can_close = false

	await get_tree().create_timer(
		0.2
	).timeout

	can_close = true


func _process(_delta):

	if dragging:

		update_wire()

	if (
		is_open
		and can_close
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):

		close_puzzle()

	if (
		dragging
		and Input.is_mouse_button_pressed(
			MOUSE_BUTTON_LEFT
		) == false
	):

		check_connection()


func randomize_layout():

	var layouts = [

		{
			"1":"yellow",
			"2":"blue",
			"3":"red"
		},

		{
			"1":"red",
			"2":"yellow",
			"3":"blue"
		},

		{
			"1":"blue",
			"2":"red",
			"3":"yellow"
		}
	]

	layout = layouts.pick_random()


func start_drag(color):

	dragging = true
	dragging_color = color

	var wire = get_wire()

	wire.visible = true
	wire.width = 14

	wire.clear_points()

	var start_pos = get_left_pos()

	wire.add_point(start_pos)
	wire.add_point(start_pos)

func update_wire():

	var wire = get_wire()

	wire.set_point_position(
		1,
		get_global_mouse_position()
	)

func check_connection():

	dragging = false

	var mouse_pos = get_global_mouse_position()

	var correct = false

	if (
		right1.get_global_rect()
		.has_point(mouse_pos)
		and layout["1"]
		== dragging_color
	):
		correct = true

	if (
		right2.get_global_rect()
		.has_point(mouse_pos)
		and layout["2"]
		== dragging_color
	):
		correct = true

	if (
		right3.get_global_rect()
		.has_point(mouse_pos)
		and layout["3"]
		== dragging_color
	):
		correct = true


	if correct:

		connected[
			dragging_color
		] = true

	else:

		get_wire().visible = false


	check_finished()


func check_finished():

	if (
		connected["blue"]
		and connected["red"]
		and connected["yellow"]
	):

		print("PUZZLE OK")

		emit_signal(
			"puzzle_finished"
		)

		close_puzzle()


func get_wire():

	match dragging_color:

		"blue":
			return wire_blue

		"red":
			return wire_red

		"yellow":
			return wire_yellow

	return null


func get_left_pos():

	match dragging_color:

		"blue":
			return left_blue.global_position

		"red":
			return left_red.global_position

		"yellow":
			return left_yellow.global_position

	return Vector2.ZERO


func close_puzzle():

	visible = false
	is_open = false
	can_close = false
