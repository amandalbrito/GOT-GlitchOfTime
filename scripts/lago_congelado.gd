extends Node2D

@onready var congelado = $Congelado
@onready var descongelado = $Descongelado
@onready var collision = $StaticBody2D/CollisionShape2D

var descongelado_ativo = false

func _ready():

	congelado.visible = true
	descongelado.visible = false

	congelado.modulate.a = 1.0
	descongelado.modulate.a = 0.0

	collision.disabled = false

func _process(_delta):

	print("Temperatura:", Global.temperatura)

	if Global.temperatura >= 50 and not descongelado_ativo:
		descongelar()

	elif Global.temperatura < 50 and descongelado_ativo:
		recongelar()

func descongelar():

	descongelado_ativo = true

	descongelado.visible = true

	var tween = create_tween()

	tween.tween_property(
		congelado,
		"modulate:a",
		0.0,
		0.5
	)

	tween.parallel().tween_property(
		descongelado,
		"modulate:a",
		1.0,
		0.5
	)

	collision.disabled = true

	await tween.finished

	congelado.visible = false

	print("Lago descongelado")

func recongelar():

	descongelado_ativo = false

	congelado.visible = true

	var tween = create_tween()

	tween.tween_property(
		congelado,
		"modulate:a",
		1.0,
		0.5
	)

	tween.parallel().tween_property(
		descongelado,
		"modulate:a",
		0.0,
		0.5
	)

	collision.disabled = false

	await tween.finished

	descongelado.visible = false

	print("Lago recongelado")
	
