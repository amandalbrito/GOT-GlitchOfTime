extends Node2D


@onready var cientista = $CientistaFinal
@onready var guardiao = $GuardiaoFinal

@onready var cientista_dialog = $CientistaFinal/DialogBox
@onready var guardian_dialog = $GuardiaoFinal/DialogBoxG

@onready var fade_rect = $FadeRect

@onready var ambientacao = $AudioStreamPlayer

func _ready():

	cientista.can_move = false
	guardiao.can_move = false

	cientista.set_process(false)
	cientista.set_physics_process(false)

	guardiao.set_process(false)
	guardiao.set_physics_process(false)

	fade_rect.visible = true
	fade_rect.color.a = 1.0

	await get_tree().process_frame

	start_cutscene()


func start_cutscene():

	ambientacao.play()

	var cientista_sprite = cientista.get_node(
		"AnimatedSprite2D"
	)

	var guardiao_sprite = guardiao.get_node(
		"AnimatedSprite2D"
	)

	# ambos olhando direita
	cientista_sprite.flip_h = false
	guardiao_sprite.flip_h = false

	cientista_sprite.play(
		"default"
	)

	guardiao_sprite.play(
		"default"
	)

	# ======================
	# FADE IN
	# ======================

	var fade_in = create_tween()

	fade_in.tween_property(
		fade_rect,
		"color:a",
		0.0,
		2.5
	)

	await fade_in.finished

	await get_tree().create_timer(
		1.5
	).timeout

	# ======================
	# CIENTISTA CAMINHA
	# ======================

	cientista_sprite.play(
		"walking"
	)

	var cientista_tween = create_tween()

	cientista_tween.tween_property(
		cientista,
		"global_position:x",
		cientista.global_position.x + 520,
		8.0
	)

	# ======================
	# GUARDIÃO APARECE
	# ======================

	await get_tree().create_timer(
		2.5
	).timeout

	guardiao_sprite.play(
		"walking"
	)

	var guardiao_tween = create_tween()

	guardiao_tween.tween_property(
		guardiao,
		"global_position:x",
		guardiao.global_position.x + 470,
		7.0
	)

	await get_tree().create_timer(
		1.5
	).timeout

	# ======================
	# ELE CHAMA ELA
	# ======================

	guardian_dialog.show_text(
		"Ei..."
	)

	await get_tree().create_timer(
		2.5
	).timeout

	guardian_dialog.show_text(
			"Espera!"
	)

	# PARA A CIENTISTA NA HORA
	cientista_tween.kill()

	cientista_sprite.play(
		"default"
	)

	await get_tree().create_timer(
		0.8
	).timeout

	# ela olha pra trás
	cientista_sprite.flip_h = true

	# guardião continua olhando direita
	guardiao_sprite.flip_h = false

	await guardiao_tween.finished

	guardiao_sprite.play(
		"default"
	)

	await get_tree().create_timer(
		1.2
	).timeout

	# ======================
	# RECONHECIMENTO
	# ======================

	cientista_dialog.show_text(
		"...você?"
	)

	await get_tree().create_timer(
		3.5
	).timeout

	cientista_dialog.show_text(
		"Espera..."
	)

	await get_tree().create_timer(
		3.0
	).timeout

	cientista_dialog.show_text(
		"É você de novo!"
	)

	await get_tree().create_timer(
		4.0
	).timeout

	cientista_dialog.show_text(
		"Você era quem estava me ajudando..."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	guardian_dialog.show_text(
		"Então era você."
	)

	await get_tree().create_timer(
		3.5
	).timeout

	guardian_dialog.show_text(
		"Eu achei que estivesse enlouquecendo."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	guardian_dialog.show_text(
		"Tudo parecia quebrado..."
	)

	await get_tree().create_timer(
		3.5
	).timeout

	cientista_dialog.show_text(
		"Você também atravessou o portal?"
	)

	await get_tree().create_timer(
		4.0
	).timeout

	guardian_dialog.show_text(
		"Não faço ideia do que aquilo era."
	)

	await get_tree().create_timer(
		3.5
	).timeout

	guardian_dialog.show_text(
		"Mas esse lugar..."
	)

	await get_tree().create_timer(
		3.0
	).timeout

	guardian_dialog.show_text(
		"...não parece pertencer a nenhum dos nossos mundos."
	)

	await get_tree().create_timer(
		4.5
	).timeout

	cientista_dialog.show_text(
		"Meu aparelho está surtando."
	)

	await get_tree().create_timer(
		3.5
	).timeout

	cientista_dialog.show_text(
		"As leituras estão completamente instáveis."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	guardian_dialog.show_text(
		"Então..."
	)

	await get_tree().create_timer(
		2.5
	).timeout

	guardian_dialog.show_text(
		"...isso ainda não acabou."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	# ======================
	# GANCHO PRA BOSS
	# ======================

	cientista_dialog.show_text(
		"...meo."
	)

	await get_tree().create_timer(
		2.5
	).timeout

	cientista_dialog.show_text(
		"Eu sinto que algo nos aguarda."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	cientista_dialog.show_text(
		"E não parece algo bom."
	)

	await get_tree().create_timer(
		4.0
	).timeout

	cientista_dialog.show_text(
		"Esteja pronto."
	)

	await get_tree().create_timer(
		4.5
	).timeout

	# ======================
	# FADE OUT
	# ======================

	var fade_out = create_tween()

	fade_out.tween_property(
		fade_rect,
		"color:a",
		1.0,
		2.5
	)

	await fade_out.finished

	get_tree().change_scene_to_file(
		"res://scenes/main/fase3.2.tscn"
	)
	
