extends Node2D

# ─── PLATAFORMA TEMPORAL ──────────────────────────────────────────────────────
# Sobe quando ativada (reusa AnimationPlayer "rise" do plataforma.gd original)
# Depois de subir, começa a piscar com glitch para o Guardião atravessar no timing
# ──────────────────────────────────────────────────────────────────────────────

var ativa        := false
var blink_active := false

var blink_on_time  := 0.5   # tempo ligada
var blink_off_time := 0.3   # tempo desligada (glitch)

@onready var anim           = $AnimationPlayer
@onready var sprite         = $Sprite2D
@onready var collision      = $StaticBody2D/CollisionShape2D

signal platform_activated


func _ready() -> void:
	if collision:
		collision.disabled = false


func activate_platform() -> void:
	if ativa:
		return
	ativa = true

	anim.play("rise")
	await anim.animation_finished

	emit_signal("platform_activated")
	_start_blink()


func _start_blink() -> void:
	blink_active = true
	_blink_loop()


func _blink_loop() -> void:
	if not blink_active:
		return

	# LIGADA
	sprite.modulate.a = 1.0
	if collision: collision.disabled = false
	await get_tree().create_timer(blink_on_time).timeout

	if not blink_active:
		return

	# DESLIGADA (glitch)
	sprite.modulate.a = 0.25
	if collision: collision.disabled = true
	await get_tree().create_timer(blink_off_time).timeout

	_blink_loop()


func stop_blink() -> void:
	blink_active = false
	sprite.modulate.a = 1.0
	if collision: collision.disabled = false


# Aumenta dificuldade reduzindo o tempo ligada (chamado pela fase)
func increase_difficulty() -> void:
	blink_on_time  = max(0.2, blink_on_time  - 0.1)
	blink_off_time = max(0.2, blink_off_time + 0.05)
