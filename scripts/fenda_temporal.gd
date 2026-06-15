extends Node2D

@onready var luz = $PointLight2D
@onready var particles = $GPUParticles2D

func _process(_delta):

	var intensidade = 1.0 - (Global.energia_temporal / 100.0)

	luz.energy = 2 + intensidade * 3
