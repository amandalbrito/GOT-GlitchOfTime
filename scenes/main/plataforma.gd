extends StaticBody2D


var activated = false


func activate_platform():

	if activated:
		return

	activated = true

	print(
		"SUBINDO PLATAFORMA"
	)

	var tween = create_tween()

	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - 500,
		4.0
	)

	await tween.finished

	print(
		"INDO PRA BOSS"
	)

	transition_to_boss()


func transition_to_boss():

	var fade = (
		get_tree()
		.current_scene
		.get_node(
			"FadeRect"
		)
	)

	fade.visible = true
	fade.color.a = 0.0

	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		1.0,
		1.5
	)

	await tween.finished

	get_tree().change_scene_to_file(
		"res://scenes/boss_fight.tscn"
	)
