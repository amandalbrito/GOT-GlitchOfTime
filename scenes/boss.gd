extends CharacterBody2D

var instability = 100
var max_instability = 100
var vulnerable = false
var dead = false
var fight_started = false
var attacking = false

var original_position : Vector2

@onready var cristal_1 =get_parent().get_node("Cristal")

@onready var cristal_2 = get_parent().get_node("Cristal2")

@onready var anim =$AnimatedSprite2D

@onready var attack_timer =$AttackTimer

@onready var vulnerable_timer =$VulnerableTimer

@onready var hurtbox =$HurtBox

var attacks_done = 0

@onready var instability_bar =get_tree().current_scene.get_node(
		 "HUD/InstabilityBar"
	)

@onready var instability_label =get_tree().current_scene.get_node(
		"HUD/InstabilityBar/InstabilityLabel"
	)

func _ready():
	add_to_group("enemy")
	# salva posição original
	original_position = global_position

	# boss mais cadenciado
	attack_timer.wait_time = 6.0

	# entrada
	anim.play("teleport_in")

	await anim.animation_finished

	anim.play("idle")

	fight_started = true

	attack_timer.start()

	print("BOSS INICIADO")

	instability_bar.max_value =max_instability

	instability_bar.value =instability

	instability_label.text ="Instabilidade: "+ str(instability)+ "%"


func _on_attack_timer_timeout():

	if dead:
		return

	if vulnerable:
		return

	if attacking:
		return

	random_attack()


func random_attack():

	attacking = true

	print("ESCOLHENDO ATAQUE")

	# agora só 2 ataques
	var attack = randi() % 2

	match attack:

		0:
			await attack_wave()

		1:
			await attack_fragments()

	attacking = false


func attack_wave():

	print("ONDA TEMPORAL")

	anim.play("attack1")

	await get_tree().create_timer(
		0.8
	).timeout

	get_parent() \
		.get_node("SpawnOnda") \
		.spawn_wave()

	print("SPAWNANDO WAVE")

	await anim.animation_finished

	attacks_done += 1

	check_vulnerability()

	if !dead:
		anim.play("idle")


func attack_fragments():

	print("FRAGMENTOS")

	anim.play("attack2")

	await get_tree().create_timer(
		0.8
	).timeout

	get_parent() \
		.get_node("SpawnFragmentos") \
		.spawn_fragments()

	await anim.animation_finished

	attacks_done += 1

	check_vulnerability()

	if !dead:
		anim.play("idle")


func become_vulnerable():

	if dead:
		return

	if vulnerable:
		return

	print("BOSS VULNERAVEL")

	vulnerable = true

	attack_timer.stop()

	anim.play("idle")

	# feedback visual no boss
	modulate = Color(
		1,
		0.5,
		0.5
	)

	# feedback nos cristais
	cristal_1.modulate = Color(
		0.4,
		1,
		1
	)

	cristal_2.modulate = Color(
		1,
		0.6,
		0.2
	)

	vulnerable_timer.start()


func _on_vulnerable_timer_timeout():

	if dead:
		return

	print("ESCUDO VOLTOU")

	vulnerable = false
	
	cristal_1.activated = false
	cristal_2.activated = false

	# reseta cor
	modulate = Color.WHITE

	cristal_1.modulate =Color.WHITE

	cristal_2.modulate =Color.WHITE

	# MUITO IMPORTANTE
	attacking = false

	anim.play("idle")

	# volta timer
	attack_timer.start()

	print("BOSS VOLTOU A ATACAR")


func take_damage():

	if !vulnerable:
		return

	if dead:
		return

	# reduz estabilidade
	instability -= 5

	instability = clamp(
		instability,
		0,
		max_instability
	)

	print(
		"INSTABILIDADE:",
		instability
	)

	# igual fase 0
	var tween =create_tween()

	tween.tween_property(
		instability_bar,
		"value",
		instability,
		0.5
	)

	instability_label.text ="Instabilidade: "+ str(instability)+ "%"

	# feedback visual
	modulate = Color(1,
		0.4,
		0.4
	)

	await get_tree().create_timer(
			0.12
		).timeout

	modulate =Color.WHITE

	# morreu
	if instability <= 0:

		instability_bar.value = 0

		die()


func die():

	if dead:
		return

	dead = true

	print(
		"BOSS MORREU"
	)

	attack_timer.stop()
	vulnerable_timer.stop()

	attacking = false
	vulnerable = false

	anim.play(
		"death"
	)

	await anim.animation_finished

	print(
		"FADE PRA CUTSCENE"
	)

	transition_to_final()
	
func transition_to_final():

	var fade = get_tree().current_scene.get_node(
		"Fade"
	)

	fade.visible = true
	fade.color.a = 0.0

	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		1.0,
		2.0
	)

	await tween.finished

	get_tree().change_scene_to_file(
		"res://scenes/final_cutscene.tscn"
	)

func check_vulnerability():

	if attacks_done >= 3:

		attacks_done = 0

		become_vulnerable()
		
func take_hit(amount = 1):

	print("TIRO ACERTOU O BOSS")

	if !vulnerable:

		print("BOSS NAO VULNERAVEL")
		return

	print("TOMANDO DANO")

	take_damage()
