extends Node2D

var player_near = false

@onready var label = $LabelInteracao

func _ready():

	label.visible = false

func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact_cientista"):

		ativar_estrutura()

func ativar_estrutura():

	Global.ponte_estabilizada = true

	print("Ponte estabilizada")

func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true
		label.visible = true

func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false
		label.visible = false
