extends Node

signal heat_started
signal heat_ended

var heat_active = false

func activate_heat(duration):

	if heat_active:
		return

	heat_active = true

	emit_signal("heat_started")

	print("Aquecimento iniciado")

	await get_tree().create_timer(duration).timeout

	heat_active = false

	emit_signal("heat_ended")

	print("Aquecimento encerrado")
