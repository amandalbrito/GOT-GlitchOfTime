extends Node

var resetando = false

@onready var cristal = $"../../../../DownView/SubViewportDown/PastWorld/CristalAncestral"

@onready var guardiao = $"../../../../DownView/SubViewportDown/PastWorld/Guardiao"

@onready var fenda = $"../FendaTemporal"

@onready var painel1 = $"../PainelEnergia1"
@onready var painel2 = $"../PainelEnergia2"
@onready var painel3 = $"../PainelEnergia3"

func _process(_delta):

	if Global.energia_temporal <= 0:

		if Global.paineis_ativados > 0 and not resetando:

			resetar_puzzle()

	if Global.paineis_ativados >= 3 and Global.cristal_ativo:

		finalizar_puzzle()

func resetar_puzzle():

	await get_tree().create_timer(2.0).timeout

	resetando = true

	print("RESET")

	Global.paineis_ativados = 0

	Global.energia_temporal = 0

	Global.cristal_ativo = false

	painel1.resetar()
	painel2.resetar()
	painel3.resetar()

	cristal.resetar()

	guardiao.desequipar_cajado()

	resetando = false

func finalizar_puzzle():

	print("FENDA ESTABILIZADA")

	get_tree().change_scene_to_file(
		"res://scenes/cutscene_2.tscn"
	)
