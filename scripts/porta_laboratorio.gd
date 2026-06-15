extends Node2D

var aberta = false

@onready var fechada = $PortaFechada2
@onready var aberta_sprite = $PortaAberta

@onready var collision = $StaticBody2D/CollisionShape2D

func _ready():

	aberta_sprite.visible = false

func _process(_delta):

	if Global.fogueira_acesa and not aberta:

		abrir_porta()

func abrir_porta():

	aberta = true

	fechada.visible = false
	aberta_sprite.visible = true

	collision.disabled = true

	print("Porta aberta")
