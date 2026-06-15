extends Node2D

var arvore_consertada = false
var bridge_fixed = false


@onready var scientist_dialog = (
	$Control/UpView/SubViewport/FutureWorld/Cientista/DialogBox
)

@onready var guardian_dialog = (
	$Control/DownView/SubViewportDown/PastWorld/Guardiao/DialogBoxG
)

@onready var scientist = (
	$Control/UpView/SubViewport/FutureWorld/Cientista
)

@onready var guardian = (
	$Control/DownView/SubViewportDown/PastWorld/Guardiao
)

@onready var instability_bar = (
	$HUD/InstabilityBar
)

@onready var instability_label = (
	$HUD/InstabilityBar/InstabilityLabel
)

@onready var death_screen = (
	$DeathScreen
)

@onready var hud = $HUD

@onready var fade_rect = (
	$Fade/FadeRect
)

func _ready():
	
	fade_rect.color.a = 0.0
	fade_rect.visible = false
	
	death_screen.modulate.a = 0.0
	
	instability_bar.value = 100

	instability_label.text = (
		"Instabilidade: 100%"
	)

	death_screen.visible = false

	scientist.can_move = false
	guardian.can_move = false

	scientist_dialog.modulate.a = 1.0
	guardian_dialog.modulate.a = 1.0

	start_intro_dialog()
	
	hud.visible = true
	death_screen.visible = false
	
func _process(delta):

	if Input.is_action_just_pressed(
		"restart"
	):

		if scientist.dead or guardian.dead:

			get_tree().reload_current_scene()


func start_intro_dialog():

	await scientist_dialog.show_text(
		"...ugh..."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await guardian_dialog.show_text(
		"..."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await scientist_dialog.show_text(
		"A explosão..."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await guardian_dialog.show_text(
		"Que estranho."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await scientist_dialog.show_text(
		"Isso não faz sentido."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await guardian_dialog.show_text(
		"As ruinas nao estavam dessa forma."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await scientist_dialog.show_text(
		"Eu estou..."
	)

	await get_tree().create_timer(
		0.4
	).timeout

	await scientist_dialog.show_text(
		"...no futuro?"
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await guardian_dialog.show_text(
		"Algo está errado."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await scientist_dialog.show_text(
		"Preciso consertar isso."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	await guardian_dialog.show_text(
		"Preciso entender isso."
	)

	await get_tree().create_timer(
		1.5
	).timeout

	var tween = create_tween()

	tween.parallel().tween_property(
		scientist_dialog,
		"modulate:a",
		0.0,
		0.8
	)

	tween.parallel().tween_property(
		guardian_dialog,
		"modulate:a",
		0.0,
		0.8
	)

	await tween.finished

	scientist_dialog.visible = false
	guardian_dialog.visible = false

	scientist.can_move = true
	guardian.can_move = true


func update_instability():

	var instability := 100

	if arvore_consertada:
		instability -= 50

	if bridge_fixed:
		instability -= 50

	var tween = create_tween()

	tween.tween_property(
		instability_bar,
		"value",
		instability,
		1.0
	)

	instability_label.text = (
		"Instabilidade: "
		+ str(instability)
		+ "%"
	)

func _on_body_entered(
	body: Node2D
) -> void:
	pass


func _on_body_exited(
	body: Node2D
) -> void:
	pass

func transition_to_cutscene():

	fade_rect.visible = true

	fade_rect.color.a = 0.0

	var tween = create_tween()

	tween.tween_property(
		fade_rect,
		"color:a",
		1.0,
		0.8
	)

	await tween.finished

	get_tree().change_scene_to_file(
		"res://scenes/transition_scene_1.tscn"
	)

func _on_hud_visibility_changed(
) -> void:
	pass
