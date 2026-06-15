extends Node2D

var player_near = false
var consertada = false

@onready var broken = $ArvoreMorta
@onready var fixed = $ArvoreViva

@onready var mensagem = get_node_or_null("BackGroundText")
@onready var texto = get_node_or_null("BackGroundText/CommandGuardiao")
@onready var timer = get_node_or_null("BackGroundText/CommandGuardiao/Timer")

func _ready():
	if mensagem:
		mensagem.visible = false

	if timer:
		timer.timeout.connect(_on_timer_timeout)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Guardiao":
		player_near = true
		mostrar_sequencia()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Guardiao":
		player_near = false

		if mensagem:
			mensagem.visible = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact_guardiao") and not consertada:
		consertar_arvore()

func consertar_arvore():

	consertada = true
	fixed.visible = true

	var tween = create_tween()

	tween.tween_property(
		broken,
		"modulate:a",
		0.0,
		0.5
	)

	tween.parallel().tween_property(
		fixed,
		"modulate:a",
		1.0,
		0.5
	)

	Global.arvore_consertada = true

	# atualiza barra
	get_tree().current_scene.arvore_consertada = true
	get_tree().current_scene.update_instability()

	print("Árvore consertada!")

func mostrar_mensagem(msg: String, tempo: float = 3.0):
	if not texto or not mensagem or not timer:
		return

	texto.text = msg
	mensagem.visible = true
	timer.start(tempo)

func mostrar_sequencia():
	mostrar_mensagem("Ajude a Cientista atravessar a ponte", 3)

	await get_tree().create_timer(3.0).timeout

	mostrar_mensagem("Pressione ENTER ou [O] para restaurar a árvore", 3)

func _on_timer_timeout() -> void:
	if mensagem:
		mensagem.visible = false
