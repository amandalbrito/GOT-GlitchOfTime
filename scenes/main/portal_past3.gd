extends Area2D


@onready var fase_3 =get_tree().current_scene


func _on_body_entered(body):

	if (
		body.name == "Guardiao"
		or body.name == "GuardiaoFinal"
	):

		fase_3.guardiao_no_portal = true

		print(
			"GUARDIAO NO PORTAL"
		)

		fase_3.check_portal_transition()


func _on_body_exited(body):

	if (
		body.name == "Guardiao"
		or body.name == "GuardiaoFinal"
	):

		fase_3.guardiao_no_portal = false
