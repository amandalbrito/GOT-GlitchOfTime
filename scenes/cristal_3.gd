extends Area2D

var activated = false


func _on_body_entered(body):

	if activated:
		return

	if (
		body.name == "GuardiaoFinal"
		or body.name == "CientistaFinal"
	):

		activated = true

		print("CRISTAL ATIVADO")

		get_parent().get_node("BOSS").become_vulnerable()

		queue_free()


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
