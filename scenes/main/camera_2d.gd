extends Camera2D


@onready var cientista =get_parent().get_node(
		"Cientista"
	)

@onready var guardiao =get_parent().get_node(
		"Guardiao"
	)


func _process(delta):

	global_position = (
		cientista.global_position
		+ guardiao.global_position
	) / 2.0
