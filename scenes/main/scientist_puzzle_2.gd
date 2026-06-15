extends Control

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

@export var blue_texture: Texture2D
@export var red_texture: Texture2D
@export var yellow_texture: Texture2D

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

	wire_blue.visible = false
	wire_red.visible = false
	wire_yellow.visible = false

	# COMEÇA O DRAG AO SEGURAR
	left_blue.button_down.connect(
		func():
			start_drag("blue")
	)

	left_red.button_down.connect(
		func():
			start_drag("red")
	)

	left_yellow.button_down.connect(
		func():
			start_drag("yellow")
	)


func open_puzzle(id):

	if is_open:
		close_puzzle()
		return

	mouse_filter = Control.MOUSE_FILTER_STOP

	current_terminal = id

	randomize_layout()
	update_right_visuals()
	reset_connections()

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
		dragging
		and !Input.is_mouse_button_pressed(
			MOUSE_BUTTON_LEFT
		)
	):
		check_connection()

	if (
		is_open
		and can_close
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):
		close_puzzle()


func randomize_layout():

	var layouts = [

		{
			"1": "yellow",
			"2": "blue",
			"3": "red"
		},

		{
			"1": "red",
			"2": "yellow",
			"3": "blue"
		},

		{
			"1": "blue",
			"2": "red",
			"3": "yellow"
		}
	]

	layout = layouts.pick_random()

func update_right_visuals():

	right1.texture_normal =get_texture(
			layout["1"]
		)

	right2.texture_normal =get_texture(
			layout["2"]
		)

	right3.texture_normal =get_texture(
			layout["3"]
		)



func get_texture(color):

	match color:

		"blue":
			return blue_texture

		"red":
			return red_texture

		"yellow":
			return yellow_texture

	return null

func start_drag(color):

	dragging = true
	dragging_color = color

	var wire = get_wire()

	wire.visible = true

	var start_pos =get_left_pos()

	wire.global_position =start_pos

	wire.rotation = 0

	wire.scale = Vector2(
		0.1,
		0.12
	)

func update_wire():

	var wire = get_wire()

	var start_pos = get_left_pos()
	var mouse_pos = get_global_mouse_position()

	var direction = (
		mouse_pos - start_pos
	)

	var max_distance = 220.0

	var distance = min(
		direction.length(),
		max_distance
	)

	wire.rotation = (
		direction.angle()
	)

	wire.global_position = (
		start_pos
		+ direction.normalized()
		* (distance / 2.0)
	)

	wire.scale = Vector2(
		distance / 500.0,
		0.12
	)

func check_connection():

	dragging = false

	var mouse_pos =	get_global_mouse_position()

	var correct := false

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


	var wire = get_wire()

	if correct:

		connected[
			dragging_color
		] = true

		print(
			"CONECTOU:",
			dragging_color
		)

	else:

		wire.visible = false


	check_finished()


func check_finished():

	if (
		connected["blue"]
		and connected["red"]
		and connected["yellow"]
	):

		print("PUZZLE OK")

		var fase = get_tree().current_scene

		fase.scientist_terminals += 1

		print(
			"TERMINAIS:",
			fase.scientist_terminals,
			"/3"
		)

		fase.check_lighthouse()

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


func reset_connections():

	connected = {
		"blue": false,
		"red": false,
		"yellow": false
	}

	wire_blue.visible = false
	wire_red.visible = false
	wire_yellow.visible = false


func close_puzzle():

	visible = false
	is_open = false
	can_close = false
	
