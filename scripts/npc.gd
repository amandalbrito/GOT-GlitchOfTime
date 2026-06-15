extends Node2D

var player_near := false
var talking := false

@onready var dialog_box = $DialogBox
@onready var label = $DialogBox/Label
@onready var exclamation = $Exclamation
@onready var voice_sound = $VoiceSound


func _ready():

	dialog_box.visible = false


func _process(_delta):

	if (
		player_near
		and not talking
		and Input.is_action_just_pressed(
			"interact_cientista"
		)
	):

		show_dialog()


func show_dialog():

	# evita spam
	if talking:
		return

	talking = true

	# some o !
	exclamation.visible = false

	dialog_box.visible = true

	var text := ""

	# fala depende da árvore
	if Global.arvore_consertada:

		text = (
			"A ponte voltou! O que será que aconteceu?"
		)

	else:

		text = (
			"Puxa, a ponte se quebrou depois desse tremor..."
		)

	# limpa label
	label.text = ""

	var count = 0

	# efeito letra por letra
	for letter in text:

		label.text += letter
		count += 1

		# som da fala
		if letter != " " and count % 2 == 0:

			voice_sound.stop()
			voice_sound.play()

			# corta rapidinho
			await get_tree().create_timer(
				0.015
			).timeout

			voice_sound.stop()

		await get_tree().create_timer(
			0.03
		).timeout

	# deixa o player ler
	await get_tree().create_timer(
		2.5
	).timeout

	dialog_box.visible = false
	talking = false


func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true


func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false
