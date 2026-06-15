extends Node2D

@onready var fragmento_base =get_parent().get_node("Fragmento")


func spawn_fragments():

	for i in range(5):

		var fragment =fragmento_base.duplicate()

		get_parent().add_child(fragment)

		fragment.name = "FragmentoClone"

		fragment.visible = true

		fragment.global_position =Vector2(
				randf_range(
					100.0,
					1100.0
				),
				-100.0
			)
