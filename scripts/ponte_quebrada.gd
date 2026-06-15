extends Node2D

var player_near = false

var ponte_final_ativa = false

@onready var raizes = $"PonteRaízes"
@onready var ponte_completa = $PonteConsertada
@onready var collision = $StaticBody2D/CollisionShape2D
@onready var collisionRaizes = $StaticBody2D2/CollisionRaizes
@onready var label = $LabelInteracao

@onready var mensagem = get_node_or_null("BackGroundText")
@onready var texto = get_node_or_null("BackGroundText/CommandGuardiao")
@onready var timer = get_node_or_null("BackGroundText/CommandGuardiao/Timer")

func _ready():

	raizes.visible = false
	ponte_completa.visible = false
	collisionRaizes.disabled = false
	label.visible = false
	
	if mensagem:
		mensagem.visible = false


func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact_guardiao"):

		if Global.cajado_equipado and not Global.raizes_ativas:

			ativar_raizes()
			collision.disabled = true
			

	if Global.ponte_estabilizada and not ponte_final_ativa:

		ponte_final_ativa = true

		ponte_completa.visible = true

		collisionRaizes.disabled = true

func ativar_raizes():

	Global.raizes_ativas = true

	raizes.visible = true

	print("Raízes ativadas")
	
	await get_tree().create_timer(0.5).timeout
	
	Global.cajado_equipado = false

func _on_area_2d_body_entered(body):

	if body.name == "Guardiao":
		mostrar_sequencia()
		player_near = true
		label.visible = true
		collision.set_deferred("disabled" , false)


func _on_area_2d_body_exited(body):
	if body.name == "Guardiao":

		player_near = false
		label.visible = false
		collision.set_deferred("disabled" , true)

func mostrar_mensagem(msg: String, tempo: float = 5.0):
	if not texto or not mensagem or not timer:
		return

	texto.text = msg
	mensagem.visible = true
	timer.start(tempo)

func mostrar_sequencia():
	mostrar_mensagem("Utilize o cajado para ativar raízes congeladas", 3)

	await get_tree().create_timer(3.0).timeout

	mostrar_mensagem("Clique no cajado e pressione ENTER ou [O] para usá-lo")

func _on_timer_timeout() -> void:
	if mensagem:
		mensagem.visible = false
