extends Node2D

@onready var scientist =$CientistaFinal

@onready var guardian =$GuardiaoFinal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_just_pressed(
		"restart"
	):

		if (
			scientist.dead
			or guardian.dead
		):

			get_tree().reload_current_scene()
