extends CharacterBody2D

const SPEED = 450
const JUMP_FORCE = -400
const GRAVITY = 900
const FALL_LIMIT = 1200

const BULLET_SPEED = 1100
const BULLET_DISTANCE = 400

var can_shoot = true
var bullet_active = false
var bullet_direction = 1
var bullet_start_position = Vector2.ZERO

var spawn_position: Vector2
var can_move = true
var dead = false

var max_health = 100
var health = 100
var is_invulnerable = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_point = $ShootPoint
@onready var bullet = $Bullet
@onready var shoot_sound = $ShootSound

@onready var cajado_visual = $MaoCajado/Cajado
@onready var glow = $PointLight2D


var device_id = 0

var move_left = false
var move_right = false
var jump = false

@onready var energy_bar = (
	get_tree().current_scene.get_node(
		"HUD/PlayerPastUI/EnergyBar"
	)
)

func _input(event):

	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event.device != device_id:
			return

	if event.is_action_pressed("move_left_guardiao"):
		print("GUARDIAO LEFT DEVICE:", event.device)

		move_left = true

	if event.is_action_released("move_left_guardiao"):
		move_left = false

	if event.is_action_pressed("move_right_guardiao"):
		print("GUARDIAO RIGHT DEVICE:", event.device)

		move_right = true

	if event.is_action_released("move_right_guardiao"):
		move_right = false

	if event.is_action_pressed("jump_guardiao"):
		jump = true

	if event.is_action_pressed("shoot_guardiao"):
		shoot()

func _ready():
	add_to_group("guardiao")

	spawn_position = global_position

	health = max_health

	update_energy_bar()

	bullet.visible = false
	bullet.scale = Vector2(2.5, 2.5)
	
	spawn_position = global_position
	if Global.cajado_equipado:
		cajado_visual.visible = true
		glow.visible = true
	else:
		cajado_visual.visible = false
		glow.visible = false


func _physics_process(delta):

	if not can_move:

		velocity = Vector2.ZERO

		animated_sprite.play("default")

		move_and_slide()

		return

	if not is_on_floor():

		velocity.y += (
			GRAVITY * delta
		)

	var direction = 0

	if move_left:
		direction -= 1

	if move_right:
		direction += 1

	velocity.x = direction * SPEED

	if jump and is_on_floor():

		velocity.y = JUMP_FORCE
		jump = false

		velocity.y = JUMP_FORCE

	if Input.is_action_just_pressed(
		"shoot_guardiao"
	):
		shoot()

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

	move_and_slide()
	if (
		global_position.y
		> FALL_LIMIT
		and can_move
	):

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

		for enemy in (
			get_tree()
			.get_nodes_in_group(
				"enemy"
			)
		):

			if (
				bullet.global_position
				.distance_to(
					enemy.global_position
				)
				< 45
			):

				if enemy.has_method(
					"take_hit"
				):
					enemy.take_hit(
						20
					)

				bullet.visible = false
				bullet_active = false

				return

		# distância máxima
		if abs(
			bullet.global_position.x
			- bullet_start_position.x
		) > BULLET_DISTANCE:

			bullet.visible = false
			bullet_active = false
		
	if Global.cajado_equipado:
		
		glow.energy = 1.5 + sin(Time.get_ticks_msec() * 0.01) * 0.3
		cajado_visual.visible = true
		glow.visible = true

	else:

		cajado_visual.visible = false
		glow.visible = false


func shoot():

	if not can_shoot:
		return

	can_shoot = false

	# TOCA SOM
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
		0.45
	).timeout

	can_shoot = true

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
		"Vida Guardião:",
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
		get_tree().current_scene
	)

	var scientist = get_tree().get_first_node_in_group(
		"cientista"
	)

	if scientist:
		scientist.can_move = false

	scene.get_node(
		"HUD"
	).visible = false

	var death_screen = (
		scene.get_node(
			"DeathScreen"
		)
	)

	death_screen.visible = true
	death_screen.modulate.a = 0.0

	var tween = create_tween()

	tween.tween_property(
		death_screen,
		"modulate:a",
		1.0,
		1.0
	)


func shake_energy_bar():

	var original_position = (
		energy_bar.global_position
	)

	for i in range(8):

		energy_bar.global_position = (
			original_position
			+ Vector2(
				randf_range(-4, 4),
				randf_range(-2, 2)
			)
		)

		await get_tree().create_timer(
			0.02
		).timeout

	energy_bar.global_position = (
		original_position
	)


func respawn():

	global_position = (
		spawn_position
	)

	velocity = Vector2.ZERO
	
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
		


func equipar_cajado():

	cajado_visual.visible = true
	glow.visible = true

	cajado_visual.scale = Vector2(0.5, 0.5)

	var tween = create_tween()

	tween.tween_property(
		cajado_visual,
		"scale",
		Vector2(1, 1),
		0.2
	)
	
func desequipar_cajado():

	Global.cajado_equipado = false

	cajado_visual.visible = false

	glow.visible = false

	print("Cajado desativado")


func _on_portal_past_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
