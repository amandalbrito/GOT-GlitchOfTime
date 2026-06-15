extends Node2D

var player_near = false
var activated = false

@export var platform_path : NodePath

var platform

@onready var off_sprite = $Sprite2D
@onready var anim = $AnimatedSprite2D

# texto tutorial
@onready var mensagem = get_node_or_null("ColorRect")
@onready var texto = get_node_or_null(
	"ColorRect/CommandCientista"
)
@onready var timer = get_node_or_null(
	"ColorRect/CommandCientista/Timer"
)


func _ready():

	print("READY")
	anim.visible = false

	platform = get_node(platform_path)

	# esconde tutorial
	if mensagem:
		mensagem.visible = false

	if timer:
		timer.timeout.connect(
			_on_timer_timeout
		)


func _process(delta):
	if Input.is_action_just_pressed("interact_cientista"):
		print("INPUT FUNCIONOU")

	if player_near:
		print("PERTO")

	if (
		player_near
		and Input.is_action_just_pressed("interact_cientista")
		and not activated
	):
		print("E APERTADO")
		activate_terminal()

func activate_terminal():

	print("ATIVANDO TERMINAL")

	activated = true

	off_sprite.visible = false
	anim.visible = true

	anim.play("activate")

	# espera animação acabar
	await anim.animation_finished

	if platform:
		platform.activate_platform()

	# pequena respirada
	await get_tree().create_timer(0.2).timeout

	# Cientista
	var scientist = get_tree().current_scene.get_node_or_null(
		"Control/UpView/SubViewport/FutureWorld/Cientista"
	)

	if not scientist:
		scientist = get_tree().current_scene.get_node_or_null(
			"Cientista"
		)

	# Guardião
	var guardian = get_tree().current_scene.get_node_or_null(
		"Control/DownView/SubViewportDown/PastWorld/Guardiao"
	)

	if not guardian:
		guardian = get_tree().current_scene.get_node_or_null(
			"Guardiao"
		)

	# Libera movimento apenas se encontrou os nós
	if scientist:
		scientist.can_move = true

	if guardian:
		guardian.can_move = true

	# terminal concluído
	if "bridge_fixed" in get_tree().current_scene:
		get_tree().current_scene.bridge_fixed = true

	if get_tree().current_scene.has_method(
		"update_instability"
	):
		get_tree().current_scene.update_instability()

func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true
		mostrar_sequencia()


func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false

		if mensagem:
			mensagem.visible = false


func mostrar_mensagem(
	msg: String,
	tempo: float = 3.0
):

	if not texto or not mensagem or not timer:
		return

	texto.text = msg
	mensagem.visible = true
	timer.start(tempo)


func mostrar_sequencia():

	mostrar_mensagem(
		"Ajude o Guardião a atravessar a floresta",
		3
	)

	await get_tree().create_timer(
		3.0
	).timeout

	if not activated:

		mostrar_mensagem(
			"Pressione [E] OU [X] para ativar o terminal",
			3
		)


func _on_timer_timeout() -> void:

	if mensagem:
		mensagem.visible = false


func _on_area_2d_term_body_entered(body: Node2D) -> void:
	print("BODY ENTERED")
	print("ENTROU:", body.name)

	if body.name == "Cientista":
		print("CIENTISTA DETECTADA")
		player_near = true
		mostrar_sequencia()
	pass # Replace with function body.


func _on_area_2d_term_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
