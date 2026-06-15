extends AnimatedSprite2D

@export var move_distance = 35.0
@export var move_speed = 2.8
@export var wind_force := 900.0
@export var upward_force := -220.0
@onready var push_area = $PushArea


var start_x = 0.0
var storm_disabled = false


func _ready() -> void:
	play("default")
	start_x = position.x


func _process(_delta) -> void:

	if storm_disabled:
		return

	position.x = start_x + sin(
		Time.get_ticks_msec() * 0.001 * move_speed
	) * move_distance

	for body in push_area.get_overlapping_bodies():

		if body.name == "Guardiao":

			# empurra de verdade pra trás
			body.global_position.x -= 420 * _delta

			# vento levanta aos poucos
			body.velocity.y -= 18

			# força horizontal MUITO forte
			body.velocity.x = -900

			# limite vertical natural
			body.velocity.y = clamp(
				body.velocity.y,
				-180,
				500
			)

			# turbulência
			body.global_position.y += randf_range(-2.0, 2.0)

			body.global_position.x += randf_range(-1.0, 0.5)

func stop_storm():

	print("TEMPESTADE PARANDO")

	storm_disabled = true
	
	
	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		2.0
	)

	await tween.finished

	queue_free()
