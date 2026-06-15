extends Node2D

@onready var guardiao = $Guardian
@onready var scientist = $Scientist

@onready var guardiao_dialogue = $Guardian/DialogueText2
@onready var scientist_dialogue = $Scientist/DialogueText

@onready var guardiao_voice_sound = $Guardian/VoiceSound
@onready var cientista_voice_sound = $Scientist/VoiceSound
@onready var ambientacao = $Ambientacao
@onready var portal_aberto = $PortalAberto

@onready var flash = $CanvasLayer/WhiteFlash
@onready var fade = $CanvasLayer/BlackFade
@onready var camera = $Camera2D

@onready var rift_glow = $RiftGlow


func _ready():

	guardiao_dialogue.visible = false
	scientist_dialogue.visible = false

	guardiao_voice_sound.stop()
	cientista_voice_sound.stop()

	flash.modulate.a = 0.0
	fade.modulate.a = 0.0

	scientist.flip_h = true

	start_cutscene()


func start_cutscene() -> void:

	# ====================
	# 1. SILÊNCIO + FENDA
	# ====================

	ambientacao.play()

	await get_tree().create_timer(1.0).timeout

	await light_shake()

	portal_aberto.play()

	for i in range(3):

		rift_glow.energy = 1.8
		flash.modulate.a = 0.12

		await get_tree().create_timer(0.15).timeout

		rift_glow.energy = 1.0
		flash.modulate.a = 0.0

		await get_tree().create_timer(0.15).timeout

	await get_tree().create_timer(1.0).timeout


	# ====================
	# 2. OS DOIS CHEGAM
	# ====================

	guardiao.play("walking")
	scientist.play("walking")

	var tween = create_tween()

	tween.parallel().tween_property(
		guardiao,
		"position:x",
		420,
		2.0
	)

	tween.parallel().tween_property(
		scientist,
		"position:x",
		860,
		2.0
	)

	await tween.finished

	guardiao.play("default")
	scientist.play("idle")

	await get_tree().create_timer(1.2).timeout


	# ====================
	# 3. PRIMEIRO CONTATO
	# ====================

	flash.modulate.a = 0.25

	await get_tree().create_timer(0.35).timeout

	flash.modulate.a = 0.0

	# passo pra frente
	var tween2 = create_tween()

	tween2.parallel().tween_property(
		guardiao,
		"position:x",
		guardiao.position.x + 40,
		1.0
	)

	tween2.parallel().tween_property(
		scientist,
		"position:x",
		scientist.position.x - 40,
		1.0
	)

	await tween2.finished

	# zoom leve
	var zoom_tween = create_tween()

	zoom_tween.tween_property(
		camera,
		"zoom",
		Vector2(1.08, 1.08),
		2.0
	)

	# diálogo
	await guardiao_speak(
		"...você é real?",
		2.0
	)

	await get_tree().create_timer(0.5).timeout

	await scientist_speak(
		"Então...\nnão estou sozinha.",
		2.5
	)


	# ====================
	# 4. REALIDADE QUEBRA
	# ====================

	portal_aberto.play()

	# Guardião percebe algo errado
	await guardiao_speak(
		"ESPERA—",
		0.4
	)

	# fenda surta
	rift_glow.energy = 4.0

	# tremor forte
	heavy_shake()

	# flashes violentos
	for i in range(8):

		flash.modulate.a = 0.5

		await get_tree().create_timer(
			0.04
		).timeout

		flash.modulate.a = 0.0

		await get_tree().create_timer(
			0.04
		).timeout

	# Cientista reage
	await scientist_speak(
		"NÃO—",
		0.5
	)

	# luz explode
	flash.modulate.a = 1.0

	await get_tree().create_timer(
		0.35
	).timeout

	flash.modulate.a = 0.0

	rift_glow.energy = 1.0


	# ====================
	# 5. FADE PRA PRETO
	# ====================

	var fade_tween = create_tween()

	fade_tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		2.0
	)

	await fade_tween.finished

	get_tree().change_scene_to_file(
		"res://scenes/transition_scene_3.tscn"
	)


func guardiao_speak(
	texto: String,
	tempo: float
):

	guardiao_dialogue.visible = true
	guardiao_dialogue.text = texto

	guardiao_voice_sound.play()
	
	await get_tree().create_timer(
		tempo
	).timeout

	guardiao_voice_sound.stop()

	guardiao_dialogue.visible = false


func scientist_speak(
	texto: String,
	tempo: float
):

	cientista_voice_sound.play()

	scientist_dialogue.visible = true
	scientist_dialogue.text = texto

	await get_tree().create_timer(
		tempo
	).timeout

	cientista_voice_sound.stop()

	scientist_dialogue.visible = false


func light_shake():

	var original = camera.position

	for i in range(12):

		camera.position = original + Vector2(
			randf_range(-2, 2),
			randf_range(-2, 2)
		)

		await get_tree().create_timer(
			0.03
		).timeout

	camera.position = original


func heavy_shake():

	var original = camera.position

	for i in range(35):

		camera.position = original + Vector2(
			randf_range(-6, 6),
			randf_range(-6, 6)
		)

		await get_tree().create_timer(
			0.03
		).timeout

	camera.position = original
