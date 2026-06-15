extends CharacterBody2D

const SPEED = 100.0
const ATTACK_RANGE = 55
const ATTACK_DAMAGE = 5
const ATTACK_COOLDOWN = 3.5

const MAX_HEALTH = 45
const DETECTION_RANGE = 320

@export var target_path: NodePath

@onready var navigation_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

var target
var can_attack = true
var taking_hit = false
var health = MAX_HEALTH
var dead = false


func _ready():

	target = get_node(target_path)

	animated_sprite.play("fly")


func _physics_process(delta):

	if dead:
		return

	if target == null:
		return

	var distance = global_position.distance_to(
		target.global_position
	)

	# ==================
	# FORA DO RANGE
	# ==================
	if distance > DETECTION_RANGE:

		velocity = Vector2.ZERO

		if animated_sprite.animation != "fly":
			animated_sprite.play("fly")

		move_and_slide()
		return

	# ==================
	# ATAQUE
	# ==================
	if distance < ATTACK_RANGE:

		velocity = Vector2.ZERO

		if animated_sprite.animation != "attack":
			animated_sprite.play("attack")

		attack()

	# ==================
	# SEGUE PLAYER
	# ==================
	else:

		navigation_agent.target_position = (
			target.global_position
		)

		var next_position = (
			navigation_agent
			.get_next_path_position()
		)

		var direction = (
			global_position.direction_to(
				next_position
			)
		)

		velocity = direction * SPEED

		if animated_sprite.animation != "fly":
			animated_sprite.play("fly")

		if velocity.x != 0:
			animated_sprite.flip_h = (
				velocity.x < 0
			)

	move_and_slide()


func attack():

	if not can_attack or dead:
		return

	can_attack = false

	await Engine.get_main_loop() \
		.create_timer(0.35).timeout

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

			print("MORDEU")

	await Engine.get_main_loop() \
		.create_timer(
			ATTACK_COOLDOWN
		).timeout

	if !dead:
		can_attack = true


func take_hit(damage = 10):

	if taking_hit or dead:
		return

	taking_hit = true

	health -= damage

	print(
		"Vida morcego:",
		health
	)

	var original_position = (
		global_position
	)

	modulate = Color(
		1,
		0.4,
		0.4
	)

	for i in range(6):

		global_position = (
			original_position
			+ Vector2(
				randf_range(-5, 5),
				randf_range(-3, 3)
			)
		)

		await get_tree() \
			.create_timer(0.02).timeout

	global_position = (
		original_position
	)

	modulate = Color.WHITE

	# ==================
	# MORREU
	# ==================
	if health <= 0:

		dead = true
		can_attack = false
		velocity = Vector2.ZERO

		animated_sprite.play(
			"die"
		)

		await get_tree().create_timer(
			0.8
		).timeout

		queue_free()
		return

	await get_tree() \
		.create_timer(0.12).timeout

	taking_hit = false
