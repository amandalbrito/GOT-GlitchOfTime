extends Area2D

var speed = 650


func _ready():

	if name == "Fragmento":
		visible = false
	else:
		visible = true


func _process(delta):

	position.y += speed * delta

	if position.y > 1000:

		if name != "Fragmento":
			queue_free()


func _on_body_entered(body):

	if (
		body.name == "GuardiaoFinal"
		or body.name == "CientistaFinal"
	):

		body.take_damage(15)

		if name != "Fragmento":
			queue_free()


func _on_timer_timeout():

	if name != "Fragmento":
		queue_free()
