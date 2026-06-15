extends Area2D


@onready var fase_3 =get_tree().current_scene


func _on_body_entered(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		fase_3.cientista_no_portal = true

		print(
			"CIENTISTA NO PORTAL"
		)

		fase_3.check_portal_transition()


func _on_body_exited(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		fase_3.cientista_no_portal = false
