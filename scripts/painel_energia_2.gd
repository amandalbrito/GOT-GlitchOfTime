extends Node2D

var player_near = false
var ativado = false

@export var id_painel = 0

@onready var label = $LabelInteracao
@onready var animation = $AnimationPlayer

func _ready():

	label.visible = false

func _process(_delta):

	if player_near and not ativado:

		if Input.is_action_just_pressed("interact_cientista"):

			ativar()

func ativar():

	ativado = true

	Global.paineis_ativados += 1

	animation.play("ativar")

	print("Painel ativado")

func resetar():

	ativado = false

	$SpriteLigado.visible = false
	$SpriteDesligado.visible = true

	$PointLight2D.energy = 0

	$GPUParticles2D.emitting = false

	print("Painel resetado")

func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true
		label.visible = true

func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false
		label.visible = false
