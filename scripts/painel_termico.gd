extends Node2D

var cientista_perto = false

@onready var control = get_tree().current_scene.get_node(
	"Control/UpView/SubViewport/FutureWorld/CanvasLayer"
)


func _process(_delta):

	if (
		cientista_perto
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):

		control.abrir_popup(self)


func _on_area_2d_body_entered(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		cientista_perto = true


func _on_area_2d_body_exited(body):

	if (
		body.name == "Cientista"
		or body.name == "CientistaFinal"
	):

		cientista_perto = false


func liberar_passagem():

	print(
		"PASSAGEM LIBERADA"
	)
