extends Node2D

@onready var panel = $PanelTribo
@onready var label = $PanelTribo/Label
@onready var voice_sound = $VoiceSound

var dialogue_playing := false
var player_near := false
var already_talked := false
var tribe_gone := false

func _ready():

	panel.visible = false


func _process(_delta):

	if (
		player_near
		and !already_talked
		and !tribe_gone
	):

		already_talked = true

		show_dialog()

	if (
		player_near
		and !tribe_gone
		and Input.is_action_just_pressed(
			"shoot_guardiao"
		)
	):

		show_force_dialog()

func type_text(texto: String):

	label.text = ""

	var letter_count := 0

	for letra in texto:

		label.text += letra

		if (
			letra != " "
			and letra != "\n"
		):

			letter_count += 1

			if letter_count % 3 == 0:

				voice_sound.pitch_scale = (
					randf_range(
						0.98,
						1.02
					)
				)

				voice_sound.play()

		await get_tree().create_timer(
			0.03
		).timeout

func show_dialog():

	if dialogue_playing:
		return

	dialogue_playing = true

	panel.visible = true

	await type_text(
		"NOS MEXER?\nNEM PENSAR!"
	)

	await get_tree().create_timer(
		1.2
	).timeout

	await type_text(
		"O espirito dos ceus\nesta irritado hoje!\nNao queira irrita-lo\nmais ainda!"
	)

	await get_tree().create_timer(
		2.5
	).timeout

	panel.visible = false

	dialogue_playing = false

func show_force_dialog():

	if dialogue_playing:
		return

	dialogue_playing = true

	panel.visible = true

	await type_text(
		"NEM MESMO\nA FORCA BRUTA\nNOS TIRA DAQUI."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	panel.visible = false

	dialogue_playing = false

func _on_area_2d_body_entered(body):

	if body.name == "Guardiao":

		player_near = true


func _on_area_2d_body_exited(body):

	if body.name == "Guardiao":

		player_near = false


func run_away():

	panel.visible = true

	await type_text(
		"O ESPIRITO DO CEU\nESTA ACORDANDO!\nFUJAM!"
	)

	await get_tree().create_timer(
		1.5
	).timeout

	panel.visible = false

	for child in get_children():

		if child.has_method(
			"run_away"
		):

			child.run_away()

			await get_tree().create_timer(
				randf_range(
					0.25,
					0.6
				)
			).timeout

	$CollisionTribo/CollisionShape2D.set_deferred(
		"disabled",
		true
	)
