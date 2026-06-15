extends Node2D

var player_near = false
var canalizando = false

@onready var desligado = $CristalDesligado

@onready var luz = $LuzCristal
@onready var label = $LabelInteracao

func _ready():

	luz.energy = 0

	label.visible = false

func _process(delta):

	if player_near:

		if Input.is_action_pressed("interact_guardiao"):

			canalizando = true

		else:

			canalizando = false

	if canalizando:

		ativar_cristal()

		Global.energia_temporal += 20 * delta

		if Global.energia_temporal > 100:
			Global.energia_temporal = 100

	else:

		Global.energia_temporal -= 10 * delta

		if Global.energia_temporal < 0:
			Global.energia_temporal = 0

func ativar_cristal():

	Global.cristal_ativo = true

	luz.energy = 2.0

func resetar():

	Global.cristal_ativo = false

	canalizando = false

	desligado.visible = true

	luz.energy = 0

	print("Cristal resetado")

func _on_area_2d_body_entered(body):

	if body.name == "Guardiao":

		player_near = true

		label.visible = true

func _on_area_2d_body_exited(body):

	if body.name == "Guardiao":

		player_near = false

		label.visible = false
