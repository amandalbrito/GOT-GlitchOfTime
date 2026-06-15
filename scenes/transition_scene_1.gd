extends Node2D

@onready var image = (
	$CanvasLayer/Image
)

@onready var narration = (
	$CanvasLayer/Narration
)

@onready var continue_text = (
	$CanvasLayer/ContinueText2
)

@onready var narrator_voice = (
	$CanvasLayer/NarratorVoice
)

var current_page := 0
var typing := false
var finished_text := false


var pages = [

	"Após a explosao temporal...\nCeleste e Ravi foram separados.",

	"A cientista despertou\nem um futuro decadente.\n\nUma cidade destruida pelo tempo...\ne pela propria humanidade.",

	"Ja Ravi...\nacordou em ruinas antigas,\nmuito antes de tudo aquilo existir.",

	"Mesmo sem se conhecerem...\nos dois começaram a alterar\no caminho um do outro.",

	"Ravi restaurou\numa ponte esquecida.\n\nSem saber...\nabriu passagem para Celeste.",

	"Celeste ativou\numa antiga plataforma.\n\nE ajudou Ravi\na continuar sua jornada.",

	"Enquanto procuravam respostas...\ncriaturas estranhas\nsurgiam pelo caminho.",

	"Celeste enfrentou\nmorcegos mutantes\nno futuro.",

	"Ravi lutou contra\ncriaturas ancestrais\ndo passado.",

	"Agora...\nos caminhos levam\na uma nova regiao.",

	"No passado,\numa tempestade bloqueia\no deserto.",

	"No futuro,\nmaquinas esquecidas parecem\nter causado o caos.",

	"E para seguir adiante...\n\nCeleste e Ravi\nprecisarao aprender\nalgo novo:",

	"Agir em sincronia."
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
		"res://scenes/main/fase_1.tscn"
		)

		return

	show_page()


func _input(event):

	if !event.is_pressed():
		return

	if event.is_action_pressed(
		"continue"
	):

		# pula digitação
		if typing:

			typing = false

			narration.text = (
				pages[current_page]
			)

			finished_text = true

			continue_text.visible = true

			return

		# próxima página
		if finished_text:

			finished_text = false

			next_page()
