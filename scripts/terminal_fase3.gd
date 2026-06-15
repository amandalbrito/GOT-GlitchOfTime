extends Node2D

# ─── TERMINAL FASE 3 ──────────────────────────────────────────────────────────
# Versão simplificada do terminal.gd para a fase final.
# Sem dependência de SubViewport — os dois personagens estão na mesma cena.
# ──────────────────────────────────────────────────────────────────────────────

var player_near := false
var activated   := false

@onready var sprite = $Sprite2D
@onready var area   = $Area2D

@onready var hint_label = get_node_or_null("HintLabel")


func _ready() -> void:
	if hint_label:
		hint_label.visible = false

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if not player_near or activated:
		return

	if Input.is_action_just_pressed("interact_cientista"):
		_activate()


func _activate() -> void:
	activated = true

	if hint_label:
		hint_label.visible = false

	# pisca verde → ativo
	var tw = create_tween()
	tw.tween_property(sprite, "modulate", Color(0.0, 2.0, 0.5), 0.3)
	await tw.finished

	print("Terminal Fase3 ativado!")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Cientista":
		player_near = true
		if hint_label and not activated:
			hint_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Cientista":
		player_near = false
		if hint_label:
			hint_label.visible = false
