extends Area2D

var player_inside = false
var activated = false

@onready var panel = $PanelObelisco
@onready var sprite = $AnimatedSprite2D


func _ready():
	panel.visible = false
	sprite.frame = 0


func _process(delta):

	if (
		player_inside
		and Input.is_action_just_pressed("ui_accept")
		and !activated
	):

		activated = true
		panel.visible = false

		play_repair()


func play_repair():

	sprite.play("default")

	await sprite.animation_finished

	sprite.pause()
	sprite.frame = sprite.sprite_frames.get_frame_count("default") - 1


func _on_body_entered(body):

	if body.name == "Guardiao":
		player_inside = true
		panel.visible = true


func _on_body_exited(body):

	if body.name == "Guardiao":
		player_inside = false
		panel.visible = false
