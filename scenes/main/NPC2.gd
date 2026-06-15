extends Node2D

@export var sway_distance := 4.0
@export var sway_speed := 1.6

var scared := false
var start_position := Vector2.ZERO
var random_offset := 0.0


func _ready():

	start_position = position

	# cada npc se mexe diferente
	random_offset = randf_range(
		0.0,
		10.0
	)


func _process(_delta):

	if scared:
		return

	var time = (
		Time.get_ticks_msec() * 0.001
	) + random_offset

	# mexe pros lados
	position.x = start_position.x + sin(
		time * sway_speed
	) * sway_distance

	# sobe/desce leve
	position.y = start_position.y + sin(
		time * 1.8
	) * 2.0

	# balancinho tipo conversa
	rotation_degrees = sin(
		time * 2.0
	) * 2.0


func run_away():

	if scared:
		return

	scared = true

	var tween = create_tween()

	# fugindo um pouco bagunçado
	tween.parallel().tween_property(
		self,
		"global_position:x",
		global_position.x + 900,
		randf_range(2.0, 3.0)
	)

	tween.parallel().tween_property(
		self,
		"global_position:y",
		global_position.y +
		randf_range(-20, 20),
		2.5
	)

	await tween.finished

	queue_free()
