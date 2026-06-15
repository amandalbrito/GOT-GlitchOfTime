extends Node2D

@onready var wave_base =get_parent().get_node("Wave")


func spawn_wave():

	var wave =wave_base.duplicate()

	get_parent().add_child(wave)

	wave.is_clone = true

	wave.visible = true

	wave.global_position =global_position
