extends CharacterBody2D

const SPEED = 90.0
const ATTACK_RANGE = 50
const ATTACK_DAMAGE = 15
const ATTACK_COOLDOWN = 1.0
const DETECTION_RANGE = 400

const MAX_HEALTH = 100

@export var target_path: NodePath
@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

var target

var can_attack = true
var taking_hit = false
var dead = false

var health = MAX_HEALTH


func _ready():

	add_to_group("enemy")

	target = get_node(target_path)

	animated_sprite.play("idle")


func _physics_process(delta):
	
	if Global.guardian_in_era2:

		velocity = Vector2.ZERO
		return
	
	# ==================
	# MORTO
	# ==================
	if dead:
		move_and_slide()
		return

	if target == null:
		return

	var distance = global_position.distance_to(
		target.global_position
	)

	# ==================
	# ATAQUE
	# ==================
	if distance < ATTACK_RANGE:

		velocity = Vector2.ZERO

		if animated_sprite.animation != "attack":
			animated_sprite.play("attack")

		attack()

	# ==================
	# DETECTOU PLAYER
	# ==================
	elif distance < DETECTION_RANGE:

		navigation_agent.target_position = (
			target.global_position
		)

		var next_position = (
			navigation_agent
			.get_next_path_position()
		)

		var direction = global_position.direction_to(
			next_position
		)

		velocity = direction * SPEED

		if animated_sprite.animation != "run":
			animated_sprite.play("run")

		# vira sprite
		if velocity.x != 0:
			animated_sprite.flip_h = (
				velocity.x > 0
			)

	# ==================
	# IDLE
	# ==================
	else:

		velocity = Vector2.ZERO

		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

	move_and_slide()


func attack():

	if dead:
		return

	if not can_attack:
		return

	can_attack = false

	# delay do hit
	await get_tree().create_timer(0.35).timeout

	if dead:
		return

	if target != null:

		var distance = (
			global_position.distance_to(
				target.global_position
			)
		)

		if distance < ATTACK_RANGE:

			target.take_damage(
				ATTACK_DAMAGE
			)

			print(
				"COGUMELO BATEU 😭"
			)

	await get_tree().create_timer(
		ATTACK_COOLDOWN
	).timeout

	can_attack = true


func take_hit(damage = 20):

	if dead:
		return

	health -= damage

	print(
		"Vida Cogumelo:",
		health
	)

	# morreu
	if health <= 0:
		die()
		return

	# evita bug de hit spam
	if taking_hit:
		return

	taking_hit = true

	animated_sprite.play("hit")

	var original_position = (
		global_position
	)

	# flash vermelho
	modulate = Color(
		1,
		0.4,
		0.4
	)

	# tremidinha
	for i in range(5):

		global_position = (
			original_position
			+ Vector2(
				randf_range(-4, 4),
				randf_range(-2, 2)
			)
		)

		await get_tree().create_timer(
			0.02
		).timeout

	global_position = (
		original_position
	)

	modulate = Color.WHITE

	await get_tree().create_timer(
		0.15
	).timeout

	taking_hit = false


func die():

	if dead:
		return

	dead = true
	can_attack = false
	taking_hit = false

	# para horizontal
	velocity.x = 0

	# desliga colisão
	collision_layer = 0
	collision_mask = 0

	# toca animação UMA vez
	animated_sprite.play("die")

	# garante que não está loopando
	animated_sprite.sprite_frames.set_animation_loop(
		"die",
		false
	)

	# espera terminar
	var frames = (
		animated_sprite
		.sprite_frames
		.get_frame_count("die")
	)

	var fps = (
		animated_sprite
		.sprite_frames
		.get_animation_speed("die")
	)

	var duration = (
		frames / fps
	)

	await get_tree().create_timer(
		duration
	).timeout

	queue_free()
