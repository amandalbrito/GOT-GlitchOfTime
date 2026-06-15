extends Area2D

var player_inside = false
var activated = false


@onready var boss =get_parent().get_node(
		"BOSS"
	)

@onready var plataforma_1 = get_parent().get_node_or_null(
		"Plataforma1"
	)

@onready var label =$Label


func _ready():

	label.visible = false


func _process(delta):

	# mostra prompt
	if (
		player_inside
		and boss.vulnerable
		and !activated
	):

		label.visible = true

	else:

		label.visible = false

	# impede interação
	if !player_inside:
		return

	if activated:
		return

	if !boss.vulnerable:
		return

	# ENTER guardião
	if (
		Input.is_action_just_pressed(
			"ui_accept"
		)
		or Input.is_action_just_pressed(
			"interact_guardiao"
		)
	):

		activated = true

		print(
			"CRISTAL GUARDIAO"
		)

		label.visible = false

		if plataforma_1:

			plataforma_1.activate_platform()

		else:

			print(
				"PLATAFORMA1 NULL"
			)


func _on_body_entered(body):

	print("ENTROU:", body.name)

	if body.name == "GuardiaoFinal":

		player_inside = true


func _on_body_exited(body):

	print("SAIU:", body.name)

	if body.name == "GuardiaoFinal":

		player_inside = false

		label.visible = false
