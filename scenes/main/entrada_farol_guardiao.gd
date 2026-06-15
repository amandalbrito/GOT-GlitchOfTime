extends Area2D

@export var player: CharacterBody2D
@export var spawn_position: Node2D

@onready var current_era = get_parent()
@onready var next_era = $"../../Era3"

@onready var fade = get_node(
	"/root/Fase1/Control/DownView/CanvasLayer/FadeRect"
)

var changed := false


func _ready():

	# desliga só o bloqueio da Era3
	$"../../Era3/StaticBody2D/CollisionShape2D".set_deferred(
		"disabled",
		true
	)


func _on_body_entered(body):

	if (
		body.name == "Guardiao"
		and !changed
	):

		changed = true
		enter_lighthouse()


func enter_lighthouse():

	fade.visible = true
	fade.color.a = 0

	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		1.0,
		0.5
	)

	await tween.finished

	# visual
	current_era.visible = false
	next_era.visible = true

	# teleporte
	player.global_position = (
		spawn_position.global_position
	)

	player.velocity = (
		Vector2.ZERO
	)

	await get_tree().physics_frame

	# reativa o limite da Era3
	$"../../Era3/StaticBody2D/CollisionShape2D".set_deferred(
		"disabled",
		false
	)

	var tween2 = create_tween()

	tween2.tween_property(
		fade,
		"color:a",
		0.0,
		0.5
	)
