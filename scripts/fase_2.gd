extends Node2D

signal state_started
signal state_ended

var active = false

func activate_temporal_state(duration):
	active = true
	emit_signal("state_started")

	await get_tree().create_timer(duration).timeout

	active = false
	emit_signal("state_ended")

func _on_hud_visibility_changed() -> void:
	pass # Replace with function body.
