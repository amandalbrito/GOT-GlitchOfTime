extends Area2D

@export var player: CharacterBody2D
@export var spawn_position: Node2D

@onready var world = get_parent()
@onready var current_era = get_parent()
@onready var next_era = $"../../Era2"

@onready var fade = get_node(
	"/root/Fase1/Control/UpView/CanvasLayer/FadeRect"
)

@onready var terminal = get_node(
	"/root/Fase1/Control/UpView/SubViewport/FutureWorld/Era1/Terminal"
)

@onready var drone = get_node(
	"/root/Fase1/Control/UpView/SubViewport/FutureWorld/Era1/Drone"
)

@onready var dialog_box = get_node(
	"/root/Fase1/Control/UpView/SubViewport/FutureWorld/Cientista/DialogBox"
)



var changed := false
var warning_cooldown := false


func _ready():

	next_era.visible = false


func _on_body_entered(body):

	if body.name != "Cientista":
		return

	if changed:
		return

	if not can_pass():

		if !warning_cooldown:

			warning_cooldown = true

			dialog_box.show_text(
				"Ainda não posso ir. Preciso resolver os problemas dessa área primeiro."
			)

			await get_tree().create_timer(
				2.0
			).timeout

			warning_cooldown = false

		return

	changed = true
	enter_lighthouse()


func can_pass() -> bool:

	var terminal_fixed = (
		terminal.get_node(
			"TerminalFixed"
		).visible
	)

	var drone_fixed = drone.fixed

	return (
		terminal_fixed
		and drone_fixed
	)


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

	current_era.visible = false

	next_era.visible = true

	next_era.get_node(
		"CollisionPortal/CollisionShape2D"
	).set_deferred(
		"disabled",
		false
	)

	player.global_position = (
		spawn_position.global_position
	)

	var tween2 = create_tween()

	tween2.tween_property(
		fade,
		"color:a",
		0.0,
		0.5
	)
