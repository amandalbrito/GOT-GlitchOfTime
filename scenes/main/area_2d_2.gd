extends Area2D

@export var player: CharacterBody2D
@export var spawn_position: Node2D

@onready var fade = get_node(
	"/root/Fase1/Control/DownView/CanvasLayer/FadeRect"
)

# ELEMENTOS ANTIGOS
@onready var bg1 = $"../BackgroundPast"
@onready var bg2 = $"../BackgroundPast2"
@onready var bg3 = $"../BackgroundPast3"
@onready var storm = $"../Storm"
@onready var chao = $"../ChaoPassado"

# NOVA "FASE"
@onready var era2 = $"../../Era2"

var changed := false

func _ready():

	era2.visible = false
	toggle_collisions(era2, false)

func _on_body_entered(body):
	print("ENCOSTOU")

	if body.name == "Guardiao" and !changed:
		print("É O PLAYER")

		changed = true
		change_fake_scene()

func change_fake_scene():

	fade.visible = true
	fade.color.a = 0

	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		1.0,
		0.8
	)

	await tween.finished

	# trava jogador durante transição
	player.can_move = false
	player.velocity = Vector2.ZERO
	
	print(
	"SPAWN:",
	spawn_position.global_position
)
	
	# teleporte
	player.global_position = (
		spawn_position.global_position
	)


	# espera física estabilizar
	await get_tree().physics_frame
	await get_tree().physics_frame

	# libera
	player.can_move = true
	# esconder visuais antigos
	if is_instance_valid(bg1):
		bg1.visible = false

	if is_instance_valid(bg2):
		bg2.visible = false

	if is_instance_valid(bg3):
		bg3.visible = false

	if is_instance_valid(storm):
		storm.visible = false

	if is_instance_valid(bg1):
		toggle_collisions(bg1, false)

	if is_instance_valid(bg2):
		toggle_collisions(bg2, false)

	if is_instance_valid(bg3):
		toggle_collisions(bg3, false)

	# NÃO FAZ ISSO:
	# toggle_collisions(chao, false)

	# ativa era2
	era2.visible = true
	Global.guardian_in_era2 = true
	toggle_collisions(era2, true)

	var tween2 = create_tween()

	tween2.tween_property(
		fade,
		"color:a",
		0.0,
		0.8
	)

func toggle_collisions(node: Node, enabled: bool):

	for child in node.get_children():

		if child is CollisionShape2D:
			child.disabled = !enabled

		toggle_collisions(child, enabled)
