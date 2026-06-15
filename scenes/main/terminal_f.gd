extends Node2D

var player_inside = false
var activated = false


func _ready():

	$AnimatedSprite2D.visible = false


func _process(delta):

	if (
		player_inside
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
		and !activated
	):

		activate_terminal()


func activate_terminal():

	activated = true

	$Sprite2D.visible = false
	$AnimatedSprite2D.visible = true

	$AnimatedSprite2D.play("default")

	await $AnimatedSprite2D.animation_finished

	print(name, " ativado")


func _on_body_exited(body: Node2D) -> void:
	
	if body.name == "Cientista":

		player_inside = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Cientista":

		player_inside = true
	pass # Replace with function body.
