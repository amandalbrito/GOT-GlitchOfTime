extends Area2D

@export var rune_id := 1

@onready var rune_puzzle = get_node(
	"/root/Fase1/RuneCanvas/RunePuzzle"
)

var player_near := false


func _process(_delta):

	if (
		player_near
		and Input.is_action_just_pressed(
			"interact_guardiao"
		)
	):

		rune_puzzle.open_puzzle(
			rune_id
		)


func _on_body_entered(body):

	if body.name == "Guardiao":

		player_near = true


func _on_body_exited(body):

	if body.name == "Guardiao":

		player_near = false
		
