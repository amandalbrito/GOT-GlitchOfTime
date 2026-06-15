extends Node2D

var ativado = false

@onready var desligado = $ReatorDesligado
@onready var ligado = $ReatorLigado

@onready var animation = $AnimationPlayer

func _ready():

	ligado.visible = false

func _process(_delta):

	if Global.fogueira_acesa and not ativado:

		ativar_reator()

func ativar_reator():

	ativado = true

	desligado.visible = false
	ligado.visible = true

	animation.play("reator_ligando")

	print("Reator ativado")
