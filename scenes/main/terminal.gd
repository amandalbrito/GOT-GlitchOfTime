extends Node2D

var player_near = false
var puzzle_open = false
var already_talked = false

@onready var storm = get_tree().root.get_node(
	"Fase1/Control/DownView/SubViewportDown/PastWorld/Era1/Storm"
)

@onready var puzzle_container = get_tree().root.get_node(
	"Fase1/PuzzleCanvas/Control"
)

@onready var puzzle = get_tree().root.get_node(
	"Fase1/PuzzleCanvas/Control/WireMiniGame"
)

@onready var darkness = get_tree().root.get_node(
	"Fase1/PuzzleCanvas/DarkOverlay"
)

@onready var dialog_box = get_tree().root.get_node(
	"Fase1/Control/UpView/SubViewport/FutureWorld/Cientista/DialogBox"
)

func _ready():

	puzzle.visible = false
	darkness.visible = false
	$ColorRect.visible = false

	if puzzle.has_signal("puzzle_completed"):
		puzzle.puzzle_completed.connect(_on_puzzle_completed)

	print("PUZZLE:", puzzle)


func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact_cientista"):

		if not puzzle_open:
			open_puzzle()
		else:
			close_puzzle()


func open_puzzle():

	print("ABRINDO PUZZLE")

	puzzle_container.visible = true
	darkness.visible = true

	puzzle.visible = true
	puzzle.queue_redraw()

	puzzle_open = true

	var cientista = get_tree().get_first_node_in_group("player")

	if cientista:
		cientista.can_move = false


func close_puzzle():

	print("FECHANDO")

	puzzle_container.visible = false
	darkness.visible = false

	puzzle_open = false

	var cientista = get_tree().get_first_node_in_group("player")

	if cientista:
		cientista.can_move = true

	puzzle.reset_puzzle()


func _on_area_2d_body_entered(body):

	if body.name == "Cientista":

		player_near = true

		$ColorRect.visible = true

		if not already_talked:

			already_talked = true

			dialog_box.show_text(
				"Uma máquina de clima? Vamos ver o que ela faz..."
			)

func _on_area_2d_body_exited(body):

	if body.name == "Cientista":

		player_near = false

		$ColorRect.visible = false

func _on_puzzle_completed():

	if storm:
		storm.stop_storm()

	close_puzzle()

	$TerminalEstragado.visible = false
	$TerminalFixed.visible = true
	
	var fase = get_tree().current_scene

	fase.storm_fixed = true
	fase.update_instability()
	get_tree().current_scene.storm_fixed = true
