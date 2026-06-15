extends CanvasLayer

signal start_game

@onready var fade = $Fade
@onready var start_button = $TextureRect/StartButton
@onready var start_sfx = $StartSFX

var game_started := false


func _ready() -> void:
	fade.modulate.a = 0.0

	# Faz o StartButton piscar
	blink_start_button()


func blink_start_button():

	var tween = create_tween()

	tween.set_loops()

	# some um pouco
	tween.tween_property(
		start_button,
		"modulate:a",
		0.2,
		0.8
	)

	# volta ao normal
	tween.tween_property(
		start_button,
		"modulate:a",
		1.0,
		0.8
	)


func _input(event):

	# tecla E
	if event is InputEventKey \
	and event.pressed \
	and event.keycode == KEY_E \
	and !game_started:

		begin_game()
	
	#controle
	if event is InputEventJoypadButton \
	and event.pressed \
	and event.button_index == JOY_BUTTON_RIGHT_SHOULDER \
	and !game_started:

		begin_game()


func _on_start_button_pressed() -> void:

	if game_started:
		return

	begin_game()


func begin_game():

	game_started = true

	# garante opacidade normal antes de esconder
	start_button.modulate.a = 1.0
	start_button.hide()

	# toca som de start
	start_sfx.volume_db = -8
	start_sfx.play()

	start_game.emit()

	# fade suave
	var tween = create_tween()

	tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		1.5
	)

	# espera um pouquinho pro som tocar
	await get_tree().create_timer(0.25).timeout

	await tween.finished

	get_tree().change_scene_to_file(
		"res://scenes/main/intro_scene.tscn"
	)
