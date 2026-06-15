extends Area2D

var speed = 700
var is_clone = false


func _ready():

	if !is_clone:
		visible = false


func _process(delta):

	if is_clone:

		# esquerda → direita
		position.x += speed * delta

		if position.x > 1600:
			queue_free()


func _on_body_entered(body):

	print("ENCOSTOU:", body.name)

	if (
		body.name == "GuardiaoFinal"
		or body.name == "CientistaFinal"
	):

		body.take_damage(20)


func _on_timer_timeout():

	if is_clone:
		queue_free()
