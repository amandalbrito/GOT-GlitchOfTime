extends Node2D

var acordou = false

@onready var dormindo = $CriaturaDormindo
@onready var acordando = $CriaturaAcordando

@onready var collision = $StaticBody2D/CollisionShape2D

func _ready():

	acordando.visible = false

func _process(_delta):

	if Global.fogueira_acesa and not acordou:

		despertar()

func despertar():

	acordou = true

	dormindo.visible = false

	acordando.visible = true

	acordando.frame = 0
	acordando.play("default")

	collision.disabled = true
	
	print("Criatura despertou")
