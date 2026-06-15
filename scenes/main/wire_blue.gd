extends Area2D

@export var terminal_id := 1

@onready var scientist_puzzle = get_node(
	"/root/Fase1/RuneCanvas/ScientistPuzzle"
)

var player_near := false
var activated := false


func _process(_delta):

	if activated:
		return

	if (
		player_near
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):

		scientist_puzzle.open_puzzle(
			terminal_id
		)


func _on_body_entered(body):

	if body.name == "Cientista":
		player_near = true


func _on_body_exited(body):

	if body.name == "Cientista":
		player_near = false


func puzzle_completed():

	activated = true

	print(
		"TERMINAL %s LIGADO"
		% terminal_id
	)
