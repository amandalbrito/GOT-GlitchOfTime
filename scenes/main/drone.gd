extends Node2D

@onready var drone_preso = $DronePreso
@onready var drone_liberto = $DroneLiberto
@onready var area = $Area2D
@onready var drone_light = $DroneLight
@onready var colorrect = $ColorRect

@onready var command_label = (
	$ColorRect/CommandCientista
)

@onready var dialog_box = get_tree().root.get_node(
	"Fase1/Control/UpView/SubViewport/FutureWorld/Cientista/DialogBox"
)

@export var tribe: Node2D

var player_near := false
var fixed := false
var fixing := false
var blink_tween: Tween


func _ready():

	drone_liberto.visible = false

	colorrect.visible = false
	command_label.text = "E"

	start_blink()


func _process(_delta):

	if fixed:
		return

	if player_near and !fixing:

		colorrect.visible = true

		if Input.is_action_just_pressed(
			"interact_cientista"
		):

			if !Global.guardian_in_era2:

				dialog_box.show_text(
					"Talvez eu deva esperar..."
				)

				return

			fix_drone()

	elif !player_near:

		colorrect.visible = false

func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true

		if !fixed and !fixing:
			colorrect.visible = true


func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false
		colorrect.visible = false


func start_blink():

	blink_tween = create_tween()
	blink_tween.set_loops()

	blink_tween.parallel().tween_property(
		drone_light,
		"energy",
		0.2,
		0.35
	)

	blink_tween.parallel().tween_property(
		drone_light,
		"scale",
		Vector2(0.8, 0.8),
		0.35
	)

	blink_tween.parallel().tween_property(
		drone_light,
		"energy",
		8.0,
		0.18
	)

	blink_tween.parallel().tween_property(
		drone_light,
		"scale",
		Vector2(2.6, 2.6),
		0.18
	)

	blink_tween.parallel().tween_property(
		drone_light,
		"energy",
		2.0,
		0.22
	)

	blink_tween.parallel().tween_property(
		drone_light,
		"scale",
		Vector2(1.5, 1.5),
		0.22
	)

	blink_tween.tween_interval(
		randf_range(0.15, 0.35)
	)


func start_soft_breath():

	if tribe:
		tribe.run_away()

	var tween = create_tween()
	tween.set_loops()

	# inspira
	tween.parallel().tween_property(
		drone_light,
		"energy",
		2.2,
		1.4
	)

	tween.parallel().tween_property(
		drone_light,
		"scale",
		Vector2(1.4, 1.4),
		1.4
	)

	# expira
	tween.parallel().tween_property(
		drone_light,
		"energy",
		1.3,
		1.8
	)

	tween.parallel().tween_property(
		drone_light,
		"scale",
		Vector2(1.15, 1.15),
		1.8
	)


func fix_drone():

	fixing = true

	# muda texto da UI
	command_label.text = (
		"consertando..."
	)

	colorrect.visible = true

	await get_tree().create_timer(
		3.0
	).timeout

	fixed = true

	if blink_tween:
		blink_tween.kill()

	drone_liberto.visible = true
	drone_liberto.modulate.a = 0.0

	var transition = create_tween()

	transition.parallel().tween_property(
		drone_preso,
		"modulate:a",
		0.0,
		0.8
	)

	transition.parallel().tween_property(
		drone_liberto,
		"modulate:a",
		1.0,
		0.8
	)

	transition.parallel().tween_property(
		drone_light,
		"energy",
		2.0,
		0.8
	)

	await transition.finished

	drone_preso.visible = false

	# reseta UI
	command_label.text = "[E] ou [X]"
	colorrect.visible = false

	drone_light.energy = 1.5
	drone_light.scale = Vector2(
		1.2,
		1.2
	)

	start_soft_breath()

	var fase = get_tree().current_scene

	fase.drone_fixed = true
	get_tree().current_scene.drone_fixed = true
	fase.update_instability()
