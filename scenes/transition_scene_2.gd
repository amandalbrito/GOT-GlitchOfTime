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

	"Após atravessarem o deserto...\nCeleste e Ravi conseguiram\nrestaurar o Farol Temporal.",

	"Mesmo separados por seculos,\nos dois começaram a compreender\nalgo estranho:",

	"As ações de um\nalteravam o caminho do outro.",

	"A tempestade diminuiu.\nRuinas voltaram a funcionar.",

	"Antigas estruturas\ndespertaram novamente.",

	"No passado,\nRavi enfrentou tribos\ne desertos esquecidos.",

	"No futuro,\nCeleste restaurou maquinas\nabandonadas pelo tempo.",

	"Mas quando o farol\nfoi ativado...\n\nalgo respondeu.",

	"Por um breve instante,\no ceu pareceu\nse rasgar.",

	"Uma presença desconhecida\nobservava atraves\nda fenda temporal.",

	"Agora...\nos rastros da instabilidade\nlevam ao norte.",

	"Uma montanha esquecida,\nconsumida pelo gelo\ne pelo tempo.",

	"No passado,\no frio congela caminhos.",

	"No futuro,\nmaquinas congeladas\nescondem respostas.",

	"E desta vez...\n\nagir em sequencia\nnao sera suficiente."
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
			"res://scenes/fase 2/fase_2.tscn"
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
