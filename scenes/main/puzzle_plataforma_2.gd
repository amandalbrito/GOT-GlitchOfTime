extends Node2D

var activated = false
var moving = false

@export var move_height := 250.0
@export var speed := 120.0

var target_position : Vector2


func _ready():

	target_position = global_position


func activate_platform():

	if activated:
		return

	activated = true
	moving = true

	target_position.y -= move_height


func _process(delta):

	if moving:

		global_position = (
			global_position.move_toward(
				target_position,
				speed * delta
			)
		)

		if (
			global_position.distance_to(
				target_position
			) < 2
		):

			moving = false
