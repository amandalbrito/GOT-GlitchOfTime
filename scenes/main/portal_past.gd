extends Area2D

@onready var manager = get_tree().root.get_node(
	"Fase1/PhaseManager"
)

func _on_body_entered(body):

	if body.name != "Guardiao":
		return

	var fase = get_tree().current_scene

	if (
		!fase.storm_fixed
		or !fase.drone_fixed
		or !fase.lighthouse_fixed
	):
		print("FASE INCOMPLETA")
		return

	manager.guardiao_chegou()


func _on_body_exited(body):

	if body.name != "Guardiao":
		return

	manager.guardiao_saiu()
