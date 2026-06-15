extends Node2D

@onready var image = (
	$CanvasLayer/Image
)

@onready var narration = (
	$CanvasLayer/Narration
)

@onready var continue_text = (
	$CanvasLayer/ContinueText
)

@onready var narrator_voice = (
	$CanvasLayer/NarratorVoice
)

var current_page := 0
var typing := false
var finished_text := false


var pages = [

	"Após estabilizarem\na fenda congelada...\n\nalgo inesperado aconteceu.",

	"Ao inves de desaparecer...\n\na instabilidade temporal\nse espalhou.",

	"O tempo começou\na falhar.",


	"Passado e futuro\ncomeçaram a colidir.",

	"Desertos surgiam\nonde antes havia gelo.\n\nFlorestas apareciam\nentre ruinas metalicas.",

	"Estruturas antigas\nse misturavam com\ntecnologia esquecida.",

	"A propria realidade\nestava se desfazendo.",


	"Por um breve instante...\n\nRavi e Celeste\nfinalmente se viram.",

	"Duas pessoas\nseparadas pelo tempo.\n\nDuas jornadas\ndiferentes.",

	"Mas...\n\no mesmo objetivo.",

	"Eles nao estavam\nsozinhos.",


	"Mas havia\nalgo mais.",

	"Algo observando\natraves das falhas\ndo tempo.",

	"Uma presenca antiga.\n\nEsquecida.",

	"Ou talvez...\n\na causa de tudo."
]


func _ready():

	continue_text.visible = false
	continue_text.modulate.a = 0.0

	start_continue_fade()

	show_page()


func start_continue_fade():

	var tween = create_tween()

	tween.set_loops()

	tween.tween_property(
		continue_text,
		"modulate:a",
		0.25,
		0.8
	)

	tween.tween_property(
		continue_text,
		"modulate:a",
		1.0,
		0.8
	)


func show_page():

	typing = true
	finished_text = false

	continue_text.visible = false

	narrator_voice.play()

	await type_text(
		pages[current_page]
	)

	typing = false
	finished_text = true

	narrator_voice.stop()

	continue_text.visible = true


func type_text(texto: String):

	narration.text = ""

	for letra in texto:

		if !typing:
			return

		narration.text += letra

		await get_tree().create_timer(
			0.025
		).timeout


func next_page():

	current_page += 1

	if current_page >= pages.size():

		print("INDO FASE1")

		get_tree().change_scene_to_file(
			"res://scenes/main/fase final.tscn"
		)

		return

	show_page()


func _input(event):

	if !event.is_pressed():
		return

	if event.is_action_pressed(
		"continue"
	):

		if typing:

			typing = false

			narration.text = (
				pages[current_page]
			)

			finished_text = true

			continue_text.visible = true

			return

		if finished_text:

			finished_text = false

			next_page()
