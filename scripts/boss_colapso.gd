extends CharacterBody2D

# ─── BOSS FINAL — GUARDIÃO DO COLAPSO ────────────────────────────────────────
# Fica estático no fundo. Só ataca.
# 3 fases de vida (1 por cristal quebrado).
# ──────────────────────────────────────────────────────────────────────────────

const GRAVITY  = 900
const FALL_LIMIT = 1400

var can_move    := false
var max_health  := 99   # 33 por cristal x 3
var health      := 99

var is_defeated := false

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar      = get_tree().current_scene.get_node_or_null("HUD/BossBar")

signal boss_hit(remaining_health)
signal boss_defeated


func _ready() -> void:
	add_to_group("enemy")
	health = max_health
	animated_sprite.play("idle")
	_update_health_bar()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()

	if global_position.y > FALL_LIMIT:
		health = 0
		_die()


func take_hit(amount: int = 33) -> void:
	if is_defeated:
		return

	health -= amount
	health  = clamp(health, 0, max_health)

	_update_health_bar()
	_hit_flash()

	emit_signal("boss_hit", health)
	print("Boss HP: ", health)

	if health <= 0:
		_die()


func _die() -> void:
	if is_defeated:
		return
	is_defeated = true
	animated_sprite.play("idle")  # congela
	emit_signal("boss_defeated")


func _hit_flash() -> void:
	animated_sprite.modulate = Color(1.0, 0.3, 0.3)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.modulate = Color.WHITE


func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = health
