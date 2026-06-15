extends Node2D

var activated = false
var original_y = 0.0


func _ready():

	original_y = position.y


func activate_platform():

	if activated:
		return

	activated = true

	var tween =create_tween()

	# sobe do chão
	tween.tween_property(
		self,
		"position:y",
		original_y - 260,
		1.0
	)

	await tween.finished

	# tempo pro player atacar
	await get_tree().create_timer(
			5.0
		).timeout

	# desce
	var tween2 =create_tween()

	tween2.tween_property(
		self,
		"position:y",
		original_y,
		1.0
	)

	await tween2.finished

	activated = false
