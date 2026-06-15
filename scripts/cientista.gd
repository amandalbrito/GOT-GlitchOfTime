extends CharacterBody2D

const SPEED = 450
const JUMP_FORCE = -400
const GRAVITY = 900
const FALL_LIMIT = 1200

const BULLET_SPEED = 1400
const BULLET_DISTANCE = 400

var move_left = false
var move_right = false
var jump = false

var spawn_position: Vector2
var can_move = true

var max_health = 100
var health = 100

var is_invulnerable = false
var dead = false

# tiro
var can_shoot = true
var bullet_active = false
var bullet_direction = 1
var bullet_start_position = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_point = $ShootPoint
@onready var bullet = $Bullet
@onready var shoot_sound = $ShootSound

@onready var energy_bar = (
	get_tree().current_scene.get_node(
		"HUD/PlayerFutureUI/EnergyBar"
	)
)
var device_id = 1

func _ready():

	print("CIENTISTA DEVICE:", device_id)

	for id in Input.get_connected_joypads():
		print("CONTROLE:", id)

	set_process_input(true)

	add_to_group("cientista")

	spawn_position = global_position

	health = max_health
	update_energy_bar()

	bullet.visible = false
	bullet.scale = Vector2(2.5, 2.5)

func _input(event):

	
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event.device != device_id:
			return
			

	if not can_move:

		move_left = false
		move_right = false
		jump = false

		return

	if event.is_action_pressed(
		"move_left_cientista"
	):
		print("CIENTISTA LEFT DEVICE:", event.device)

		move_left = true

	if event.is_action_released(
		"move_left_cientista"
	):
		move_left = false

	if event.is_action_pressed(
		"move_right_cientista"
	):
		
		print("CIENTISTA RIGHT DEVICE:", event.device)

		move_right = true

	if event.is_action_released(
		"move_right_cientista"
	):
		move_right = false

	if event.is_action_pressed(
		"jump_cientista"
	):
		jump = true

	# TIRO
	if event.is_action_pressed(
		"shoot_cientista"
	):
		shoot()


func _physics_process(delta):

	# trava movimento
	if not can_move:

		velocity = Vector2.ZERO

		animated_sprite.play(
			"default"
		)

		move_and_slide()

		return

	# gravidade
	if not is_on_floor():

		velocity.y += (
			GRAVITY * delta
		)

	# movimento
	var direction = 0

	if move_left:
		direction -= 1

	if move_right:
		direction += 1

	velocity.x = (
		direction * SPEED
	)

	# animações
	if not is_on_floor():

		animated_sprite.play(
			"jump"
		)

	elif direction != 0:

		animated_sprite.play(
			"walking"
		)

		animated_sprite.flip_h = (
			direction < 0
		)

	else:

		animated_sprite.play(
			"default"
		)

	# pulo
	if jump and is_on_floor():

		velocity.y = (
			JUMP_FORCE
		)

		jump = false

	move_and_slide()

	# caiu do mapa = morreu
	if global_position.y > FALL_LIMIT:

		if not dead:
			health = 0
			update_energy_bar()
			die()

	# =================
	# BALA
	# =================

	if bullet_active:

		bullet.position.x += (
			BULLET_SPEED
			* bullet_direction
			* delta
		)

		# colisão simples
		for enemy in (
			get_tree()
			.get_nodes_in_group(
				"enemy"
			)
		):

			if (
				bullet.global_position.distance_to(
					enemy.global_position
				)
				< 45
			):

				if enemy.has_method("take_hit"):
					enemy.take_hit()
					
				bullet.visible = false
				bullet_active = false

				return

		# limite distância
		if abs(
			bullet.global_position.x
			- bullet_start_position.x
		) > BULLET_DISTANCE:

			bullet.visible = false
			bullet_active = false

func shoot():

	if not can_shoot:
		return

	can_shoot = false

	# SOM DO TIRO
	shoot_sound.pitch_scale = randf_range(
		0.97,
		1.03
	)

	shoot_sound.play()

	bullet.visible = true
	bullet_active = true

	# nasce na mão
	bullet.global_position = (
		shoot_point.global_position
	)

	bullet_start_position = (
		bullet.global_position
	)

	# direção
	if animated_sprite.flip_h:

		bullet_direction = -1
		bullet.flip_h = true

	else:

		bullet_direction = 1
		bullet.flip_h = false

	# cooldown
	await get_tree().create_timer(
		0.3
	).timeout

	can_shoot = true


func respawn():

	global_position = (
		spawn_position
	)

	velocity = Vector2.ZERO


func take_damage(amount):

	if is_invulnerable:
		return

	health -= amount

	health = clamp(
		health,
		0,
		max_health
	)

	update_energy_bar()
	shake_energy_bar()
	await hit_feedback()

	print(
		"Vida:",
		health
	)

	# morreu
	if health <= 0:

		die()

		return

	# invulnerabilidade
	is_invulnerable = true

	await get_tree().create_timer(
		1.0
	).timeout

	is_invulnerable = false


func update_energy_bar():

	energy_bar.value = health


func die():

	if dead:
		return

	dead = true
	can_move = false

	var scene = (
		get_tree()
		.current_scene
	)

	# trava guardião
	var guardian = get_tree().get_first_node_in_group(
		"guardiao"
	)

	if guardian:
		guardian.can_move = false

	# some HUD
	scene.get_node(
		"HUD"
	).visible = false

	# death screen
	var death_screen = (
		scene.get_node(
			"DeathScreen"
		)
	)

	death_screen.visible = true
	death_screen.modulate.a = 0.0

	# fade
	var tween = create_tween()

	tween.tween_property(
		death_screen,
		"modulate:a",
		1.0,
		0.8
	)


func shake_energy_bar():

	var original_position = (
		energy_bar.global_position
	)

	for i in range(8):

		energy_bar.global_position = (
			original_position
			+ Vector2(
				randf_range(
					-4,
					4
				),
				randf_range(
					-2,
					2
				)
			)
		)

		await get_tree().create_timer(
			0.02
		).timeout

	energy_bar.global_position = (
		original_position
	)
	
func hit_feedback():

	var original_position = (
		animated_sprite.position
	)

	animated_sprite.modulate = Color(
		1,
		0.35,
		0.35
	)

	for i in range(6):

		animated_sprite.position = (
			original_position
			+ Vector2(
				randf_range(-4, 4),
				randf_range(-2, 2)
			)
		)

		await get_tree().create_timer(
			0.02
		).timeout

	animated_sprite.position = (
		original_position
	)

	animated_sprite.modulate = (
		Color.WHITE
	)


func _on_portal_future_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
