extends Node2D

@export var sway_speed := 1.2

@onready var animated_sprite = (
	$AnimatedSprite2D
)

var scared := false
var start_position := Vector2.ZERO
var random_offset := 0.0


func _ready():

	start_position = position

	random_offset = randf_range(
		0.0,
		10.0
	)

	# começa parado
	if animated_sprite:
		animated_sprite.play(
			"default"
		)


func _process(_delta):

	if scared:
		return

	var time = (
		Time.get_ticks_msec() * 0.001
	) + random_offset

	# sobe e desce bem pouco
	position.y = (
		start_position.y
		+ sin(
			time * sway_speed
		) * 1.5
	)

	# mini inclinação
	rotation_degrees = sin(
		time * 1.8
	) * 0.3


func run_away():

	if scared:
		return

	scared = true

	if animated_sprite:
		animated_sprite.play(
			"walking"
		)

	await get_tree().process_frame

	var collision = get_node_or_null(
		"StaticBody2D/CollisionShape2D"
	)

	if collision:
		collision.set_deferred(
			"disabled",
			true
		)

	rotation_degrees = 0

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"global_position:x",
		global_position.x + 900,
		randf_range(2.0, 3.0)
	)

	tween.parallel().tween_property(
		self,
		"global_position:y",
		global_position.y
		+ randf_range(-15, 15),
		2.5
	)

	await tween.finished

	queue_free()
