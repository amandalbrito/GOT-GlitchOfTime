extends Node2D

# ─── CRISTAL TEMPORAL ─────────────────────────────────────────────────────────
# Passo 1: Guardião ativa com cajado (interact_guardiao)
# Passo 2: Cientista usa relógio (interact_cientista) → QUEBRA e boss toma dano
# ──────────────────────────────────────────────────────────────────────────────

var guardiao_near  := false
var cientista_near := false

var guardiao_charged := false   # guardião já ativou
var broken           := false   # cristal já foi quebrado

@onready var sprite          = $Sprite2D
@onready var glow            = $Glow
@onready var hint_guardiao   = get_node_or_null("HintGuardiao")
@onready var hint_cientista  = get_node_or_null("HintCientista")

signal crystal_broken


func _ready() -> void:
	if hint_guardiao:  hint_guardiao.visible = false
	if hint_cientista: hint_cientista.visible = false
	if glow:           glow.modulate.a = 0.3


func _process(_delta: float) -> void:
	if broken:
		return

	# ── Guardião perto → mostra dica ──
	if guardiao_near and not guardiao_charged:
		if hint_guardiao: hint_guardiao.visible = true
		if Input.is_action_just_pressed("interact_guardiao"):
			_guardiao_charge()
	else:
		if hint_guardiao: hint_guardiao.visible = false

	# ── Cientista perto → mostra dica (só se guardião carregou) ──
	if cientista_near and guardiao_charged:
		if hint_cientista: hint_cientista.visible = true
		if Input.is_action_just_pressed("interact_cientista"):
			_cientista_break()
	else:
		if hint_cientista: hint_cientista.visible = false


func _guardiao_charge() -> void:
	guardiao_charged = true

	# brilha azul
	var tw = create_tween()
	tw.tween_property(glow, "modulate", Color(0.3, 0.6, 1.0, 1.0), 0.4)
	tw.parallel().tween_property(sprite, "modulate", Color(0.7, 0.9, 1.0), 0.4)
	await tw.finished

	# pulsa
	for i in range(3):
		sprite.scale = Vector2(1.1, 1.1)
		await get_tree().create_timer(0.1).timeout
		sprite.scale = Vector2(1.0, 1.0)
		await get_tree().create_timer(0.1).timeout

	if hint_guardiao: hint_guardiao.visible = false
	print("Cristal carregado pelo Guardião!")

	# notifica fase
	var fase = get_tree().current_scene
	if fase.has_method("guardiao_activate_crystal"):
		fase.guardiao_activate_crystal(self)


func _cientista_break() -> void:
	broken = true
	if hint_cientista: hint_cientista.visible = false

	# QUEBRA — flash dourado + some
	var tw = create_tween()
	tw.tween_property(sprite, "modulate", Color(1.0, 0.9, 0.2, 0.0), 0.5)
	tw.parallel().tween_property(glow,   "modulate:a", 0.0, 0.5)
	await tw.finished

	emit_signal("crystal_broken")

	# notifica fase
	var fase = get_tree().current_scene
	if fase.has_method("cientista_break_crystal"):
		fase.cientista_break_crystal(self)

	visible = false


# ─── DETECÇÃO DE PROXIMIDADE ──────────────────────────────────────────────────
func _on_area_guardiao_body_entered(body: Node2D) -> void:
	if body.name == "Guardiao":
		guardiao_near = true

func _on_area_guardiao_body_exited(body: Node2D) -> void:
	if body.name == "Guardiao":
		guardiao_near = false

func _on_area_cientista_body_entered(body: Node2D) -> void:
	if body.name == "Cientista":
		cientista_near = true

func _on_area_cientista_body_exited(body: Node2D) -> void:
	if body.name == "Cientista":
		cientista_near = false
