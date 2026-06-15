extends Node2D

var player_near = false

@onready var fogo = $FogoAceso
@onready var apagada = $FogueiraApagada

func _ready():

	fogo.visible = false
	
func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact_guardiao"):

		if Global.cajado_equipado and not Global.fogueira_acesa:

			acender_fogueira()

func acender_fogueira():

	Global.fogueira_acesa = true

	Global.add_instability(-10)

	fogo.visible = true

	print("Fogueira acesa")

	await get_tree().create_timer(0.5).timeout
	
	Global.cajado_equipado = false

func _on_area_2d_body_entered(body):

	if body.name == "Guardiao":

		player_near = true

func _on_area_2d_body_exited(body):

	if body.name == "Guardiao":

		player_near = false
