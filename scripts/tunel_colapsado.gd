extends Node2D

@onready var fechado = $ColorRect/TunelFechado
@onready var sustentado = $TunelSustentado
@onready var collision = $StaticBody2D/CollisionShape2D

func _ready():

	sustentado.visible = false

func _process(_delta):

	if Global.raizes_ativas:

		fechado.visible = false
		sustentado.visible = true
	
		Global.add_instability(-1)
		
		collision.disabled = true
