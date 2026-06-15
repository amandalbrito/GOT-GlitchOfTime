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

		if letter != " " and count % 2 == 0:
			if not voice_sound.playing:
				voice_sound.play()

		await get_tree().create_timer(0.025).timeout

	voice_sound.stop()
