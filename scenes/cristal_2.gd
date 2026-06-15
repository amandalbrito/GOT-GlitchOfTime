extends Area2D

var player_inside = false
var activated = false


@onready var boss =get_parent().get_node(
		"BOSS"
	)

@onready var plataforma_2 =get_parent().get_node(
		"Plataforma2"
	)

@onready var label =$Label


func _ready():

	label.visible = false


func _process(delta):

	# feedback visual
	label.visible = (
		player_inside
		and boss.vulnerable
		and !activated
	)

	if !player_inside:
		return

	if activated:
		return

	# boss precisa estar vulnerável
	if !boss.vulnerable:
		return

	# E cientista
	if Input.is_action_just_pressed(
		"interact_cientista"
	):

		activated = true

		print(
			"CRISTAL 2 ATIVADO"
		)

		label.visible = false

		plataforma_2.activate_platform()


func _on_body_entered(body):

	if body.name == "CientistaFinal":

		player_inside = true


func _on_body_exited(body):

	if body.name == "CientistaFinal":

		player_inside = false
		label.visible = false
