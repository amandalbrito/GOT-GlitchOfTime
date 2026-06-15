extends Node2D

@onready var guardian = (
	$Control/DownView/SubViewportDown/PastWorld/Era1/Guardiao
)

@onready var guardian_dialog = (
	$Control/DownView/SubViewportDown/PastWorld/Era1/Guardiao/DialogBoxG
)


@onready var scientist = (
	$Control/UpView/SubViewport/FutureWorld/Cientista
)

@onready var instability_bar = (
	$HUD/InstabilityBar
)

@onready var instability_label = (
	$HUD/InstabilityBar/InstabilityLabel
)

@onready var fade_rect = (
	$Fade/FadeRect
)

var guardian_in_era2 = false
var storm_fixed = false
var drone_fixed = false
var lighthouse_fixed = false
var lighthouse_progress = 0
var guardian_ready := false
var scientist_ready := false
var changing_phase := false
var guardian_runes := 0
var scientist_terminals := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guardian.can_move = false
	fade_rect.visible = false
	fade_rect.color.a = 0.0
	start_intro_dialog()

func start_intro_dialog():

	guardian_dialog.visible = true

	await guardian_dialog.show_text(
		"..."
	)
	
	await get_tree().create_timer(
		0.5
	).timeout
	
	await guardian_dialog.show_text(
		"Eu não vou conseguir passar com essa ventania toda."
	)

	await get_tree().create_timer(
		0.5
	).timeout

	guardian_dialog.visible = false

	guardian.can_move = true
	
		# começa em 100%
	instability_bar.value = 100

	instability_label.text = (
		"Instabilidade: 100%"
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_instability():

	print("ATUALIZANDO")

	var instability := 100

	if storm_fixed:
		instability -= 30

	if drone_fixed:
		instability -= 35

	if lighthouse_fixed:
		instability -= 35

	print(instability)

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
	


func check_lighthouse():

	print(
		"RUNAS:",
		guardian_runes,
		"/3"
	)

	print(
		"TERMINAIS:",
		scientist_terminals,
		"/3"
	)

	if (
		guardian_runes >= 3
		and scientist_terminals >= 3
	):

		if lighthouse_fixed:
			return

		lighthouse_fixed = true

		print(
			"FAROL COMPLETO"
		)

		update_instability()

func check_phase_transition():

	if changing_phase:
		return

	if (
		guardian_ready
		and scientist_ready
	):

		changing_phase = true

		print("INDO CUTSCENE")

		transition_to_cutscene()

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
		"res://scenes/transition_scene_2.tscn"
	)
