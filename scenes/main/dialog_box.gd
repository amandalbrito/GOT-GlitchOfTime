extends Panel

@onready var label = $Label
@onready var voice_sound = $VoiceSound

func _ready():

	visible = false


func show_text(text):

	visible = true

	label.text = ""

	var count = 0

	for letter in text:

		label.text += letter
		count += 1

		if (
			letter != " "
			and count % 2 == 0
		):

			voice_sound.stop()
			voice_sound.play()

			await get_tree().create_timer(
				0.015
			).timeout

			voice_sound.stop()

		await get_tree().create_timer(
			0.012
		).timeout

	await get_tree().create_timer(
		2.5
	).timeout

	visible = false
