extends Node2D


var cientista_no_portal = false
var guardiao_no_portal = false


func _process(delta):

	if (
		cientista_no_portal
		and guardiao_no_portal
		and Input.is_action_just_pressed(
			"ui_accept"
		)
	):

		print("INDO PRA FASE 3.2")

		get_tree().change_scene_to_file(
			"res://scenes/main/fase3.2.tscn"
		)


func _on_portal_future_body_entered(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		cientista_no_portal = true

		print("CIENTISTA NO PORTAL")


func _on_portal_future_body_exited(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		cientista_no_portal = false


func _on_portal_past_body_entered(body):

	if (
		body.name == "Guardiao"
		or body.name == "GuardiaoFinal"
	):

		guardiao_no_portal = true

		print("GUARDIAO NO PORTAL")


func _on_portal_past_body_exited(body):

	if (
		body.name == "Guardiao"
		or body.name == "GuardiaoFinal"
	):

		guardiao_no_portal = false
