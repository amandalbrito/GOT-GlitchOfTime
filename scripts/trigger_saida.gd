extends Area2D

# ─── TRIGGER DE SAÍDA — PUZZLE 2 ─────────────────────────────────────────────
# Detecta quando o Guardião atravessou a plataforma temporal
# ──────────────────────────────────────────────────────────────────────────────

var triggered := false


func _ready() -> void:
	set_meta("triggered", false)
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.name == "Guardiao":
		triggered = true
		set_meta("triggered", true)
		print("Guardião passou pelo Puzzle 2!")
