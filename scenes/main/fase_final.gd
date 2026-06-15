extends Node2D


var cientista_no_portal = false
var guardiao_no_portal = false


func check_portal_transition():

	if (
		cientista_no_portal
		and guardiao_no_portal
	):

		print(
			"INDO PRA FASE 3.2"
		)

		await get_tree().create_timer(
			0.7
		).timeout

		get_tree().change_scene_to_file(
			"res://scenes/cutscene_encontro.tscn"
		)
