extends Node2D

@onready var broken = $PonteQuebrada
@onready var fixed = $PonteConsertada
@onready var collision = $"../StaticBody2D/CollisionShape2D"


func _ready():

	fixed.visible = false
	broken.visible = true
	collision.disabled = false


func _process(_delta):

	if (
		Global.arvore_consertada
		and broken.visible
	):

		fixed.visible = true

		var tween = create_tween()

		tween.tween_property(
			broken,
			"modulate:a",
			0.0,
			0.6
		)

		tween.parallel().tween_property(
			fixed,
			"modulate:a",
			1.0,
			0.6
		)

		collision.disabled = true
		broken.visible = false

		# NPC reage
		var npc = get_node("../NPC")

		npc.get_node(
			"Exclamation"
		).visible = true
