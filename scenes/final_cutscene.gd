extends Node2D


@onready var cientista = $CientistaFinal
@onready var guardiao = $GuardiaoFinal

@onready var cientista_dialog =$CientistaFinal/DialogBox

@onready var guardian_dialog =$GuardiaoFinal/DialogBoxG

@onready var fade = $Fade
@onready var credits = $Credits
@onready var got_logo = $GOT

@onready var ambientacao = $AudioStreamPlayer

func _ready():

	cientista.can_move = false
	guardiao.can_move = false

	cientista.set_process(false)
	guardiao.set_process(false)

	cientista.set_physics_process(false)
	guardiao.set_physics_process(false)

	cientista.velocity = Vector2.ZERO
	guardiao.velocity = Vector2.ZERO

	got_logo.visible = false
	credits.visible = false

	got_logo.modulate.a = 0.0
	credits.modulate.a = 0.0
	fade.color.a = 0.0

	start_cutscene()


func start_cutscene():

	ambientacao.play()

	var guardiao_sprite =guardiao.get_node(
			"AnimatedSprite2D"
		)

	var cientista_sprite =cientista.get_node(
			"AnimatedSprite2D"
		)

	# olhando um pro outro
	guardiao_sprite.flip_h = true
	cientista_sprite.flip_h = false

	guardiao_sprite.play("default")
	cientista_sprite.play("default")

	# ======================
	# CENA 1 — PÓS BOSS
	# ======================

	await get_tree().create_timer(
		1.5
	).timeout

	await cientista_dialog.show_text(
		"Ufa..."
	)

	await get_tree().create_timer(
		1.8
	).timeout

	await cientista_dialog.show_text(
		"Parece que conseguimos."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	await guardian_dialog.show_text(
		"Por um momento..."
	)

	await get_tree().create_timer(
		1.3
	).timeout

	await guardian_dialog.show_text(
		"Pensei que tudo fosse acabar."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	await cientista_dialog.show_text(
		"Eu também."
	)

	await get_tree().create_timer(
		1.2
	).timeout

	await cientista_dialog.show_text(
		"Mas funcionou."
	)

	await get_tree().create_timer(
		2.2
	).timeout

	# ======================
	# CENA 2 — AGRADECIMENTO
	# ======================

	await guardian_dialog.show_text(
		"Obrigado."
	)

	await get_tree().create_timer(
		1.3
	).timeout

	await guardian_dialog.show_text(
		"Se não fosse você..."
	)

	await get_tree().create_timer(
		1.2
	).timeout

	await guardian_dialog.show_text(
		"...eu não teria conseguido."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	await cientista_dialog.show_text(
		"Heh..."
	)

	await get_tree().create_timer(
		1.0
	).timeout

	await cientista_dialog.show_text(
		"Acho que eu devia agradecer também."
	)

	await get_tree().create_timer(
		1.5
	).timeout

	await cientista_dialog.show_text(
		"Nós salvamos isso juntos."
	)

	await get_tree().create_timer(
		2.5
	).timeout

	# ======================
	# CENA 3 — FINAL
	# ======================

	await guardian_dialog.show_text(
		"E agora?"
	)

	await get_tree().create_timer(
		2.2
	).timeout

	# limpa diálogo guardião
	guardian_dialog.visible = false

	if guardian_dialog.has_node(
		"Label"
	):
		guardian_dialog.get_node(
			"Label"
		).text = ""

	await cientista_dialog.show_text(
		"A gente segue em frente."
	)

	await get_tree().create_timer(
		1.8
	).timeout

	await cientista_dialog.show_text(
		"Dessa vez..."
	)

	await get_tree().create_timer(
		1.8
	).timeout

	await cientista_dialog.show_text(
		"...separados."
	)

	await get_tree().create_timer(
		3.0
	).timeout

	# limpa diálogo cientista
	cientista_dialog.visible = false

	if cientista_dialog.has_node(
		"Label"
	):
		cientista_dialog.get_node(
			"Label"
		).text = ""

	# ======================
	# VIRA E ANDA
	# ======================

	# cientista -> esquerda
	cientista_sprite.flip_h = true

	# guardião -> direita
	guardiao_sprite.flip_h = false

	# walking
	cientista_sprite.play(
		"walking"
	)

	guardiao_sprite.play(
		"walking"
	)

	var tween =create_tween()

	# cientista esquerda
	tween.parallel().tween_property(
		cientista,
		"global_position:x",
		cientista.global_position.x - 900,
		10.0
	)

	# guardião direita
	tween.parallel().tween_property(
		guardiao,
		"global_position:x",
		guardiao.global_position.x + 900,
		10.0
	)

	await tween.finished

	# ======================
	# FADE PRETO
	# ======================

	var fade_tween =create_tween()

	fade_tween.tween_property(
		fade,
		"color:a",
		1.0,
		3.0
	)

	await fade_tween.finished

	# ======================
	# LOGO GOT
	# ======================

	got_logo.visible = true
	got_logo.modulate.a = 0.0

	var got_tween =create_tween()

	got_tween.tween_property(
		got_logo,
		"modulate:a",
		1.0,
		2.5
	)

	await got_tween.finished

	await get_tree().create_timer(
		3.5
	).timeout

	var got_fade_out =create_tween()

	got_fade_out.tween_property(
		got_logo,
		"modulate:a",
		0.0,
		2.0
	)

	await got_fade_out.finished

	got_logo.visible = false

	# ======================
	# OBRIGADA POR JOGAR
	# ======================

	credits.visible = true

	# força reset visual
	credits.self_modulate = Color(
		1,
		1,
		1,
		0
	)

	var credits_tween =create_tween()

	credits_tween.tween_property(
		credits,
		"self_modulate:a",
		1.0,
		2.5
	)

	await credits_tween.finished

	# fica um tempo na tela
	await get_tree().create_timer(
		4.0
	).timeout

	# fade out do obrigada por jogar
	var credits_fade_out =create_tween()

	credits_fade_out.tween_property(
		credits,
		"self_modulate:a",
		0.0,
		2.0
	)

	await credits_fade_out.finished

	credits.visible = false
