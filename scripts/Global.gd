extends Node2D

var arvore_consertada = false
var guardian_in_era2 = false

var lago_descongelado = false

var temperatura = -40

var raizes_ativas = false
var ponte_estabilizada = false

var cajado_equipado = false

var fogueira_acesa = false

var energia_temporal = 0.0

var paineis_ativados = 0

var cristal_ativo = false

#BARRA INSTABILIDADE E SÍMBOLO ECO
var instability = 100
var echo_active = false

#BARRAS DOS PALYERS
var past_life = 100
var past_energy = 100
var past_inventory = {}

var future_energy = 100
var future_stability = 100
var future_inventory = {}

#SISTEMA DE PONTOS
var score = 0
var level_start_score = 0
var stability_points = 0
var level_start_stability_points = 0
var chaos_points = 0
var level_start_chaos_points = 0

#CHECKPOINT
var checkpoint_data = {}

var has_setup = false
var allow_crossed_wires = null
var only_cardinals = null

signal instability_changed(value)
signal echo_changed(state)
signal past_status_changed(life, energy)
signal future_status_changed(energy, stability)
signal inventory_changed
signal score_changed(total, stability, chaos)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_instability(value):
	instability += value
	instability = clamp(instability, 0, 100)
	emit_signal("instability_changed", instability)

func set_echo(state):
	echo_active = state
	emit_signal("echo_changed", echo_active)

#Atualizar barras dos Personagens
func update_past(life_delta, energy_delta):
	past_life = clamp(past_life + life_delta, 0, 100)
	past_energy = clamp(past_energy + energy_delta, 0, 100)
	emit_signal("past_status_changed", past_life, past_energy)

func update_future(energy_delta, stability_delta):
	future_energy = clamp(future_energy + energy_delta, 0, 100)
	future_stability = clamp(future_stability + stability_delta, 0, 100)
	emit_signal("future_status_changed", future_energy, future_stability)


#Inventário dos Persongens 
func add_item(player, item, amount := 1):
	if player == "past":
		past_inventory[item] = past_inventory.get(item, 0) + amount
	else:
		future_inventory[item] = future_inventory.get(item, 0) + amount
	
	emit_signal("inventory_changed")
	
func remove_item(player, item, amount := 1):
	var inv = past_inventory if player == "past" else future_inventory
	
	if inv.has(item):
		inv[item] -= amount
		if inv[item] <= 0:
			inv.erase(item)
	
	emit_signal("inventory_changed")

#SISTEMA DE PONTOS ESTABILIDADE + CAOS
func add_stability_points(value):
	stability_points += value
	score += value
	emit_signal("score_changed", score, stability_points, chaos_points)

func add_chaos_points(value):
	chaos_points += value
	score += value
	emit_signal("score_changed", score, stability_points, chaos_points)

func save_level_score():
	level_start_score = score
	level_start_stability_points = stability_points
	level_start_chaos_points = chaos_points


func reset_to_level_score():
	score = level_start_score
	stability_points = level_start_stability_points
	chaos_points = level_start_chaos_points
	emit_signal("score_changed", score, stability_points, chaos_points)
	
#Salvar CheckPoint
func save_checkpoint():
	checkpoint_data = {
		"instability": instability,
		"echo_active": echo_active,
		
		"past_life": past_life,
		"past_energy": past_energy,
		"future_energy": future_energy,
		"future_stability": future_stability,
		
		"past_inventory": past_inventory.duplicate(),
		"future_inventory": future_inventory.duplicate(),
		
		"score": score,
		"stability_points": stability_points,
		"chaos_points": chaos_points
	}

#Atualizar CheckPoint
func load_checkpoint():
	if checkpoint_data.is_empty():
		return
	
	instability = checkpoint_data["instability"]
	echo_active = checkpoint_data["echo_active"]
	
	past_life = checkpoint_data["past_life"]
	past_energy = checkpoint_data["past_energy"]
	
	future_energy = checkpoint_data["future_energy"]
	future_stability = checkpoint_data["future_stability"]
	
	past_inventory = checkpoint_data["past_inventory"].duplicate()
	future_inventory = checkpoint_data["future_inventory"].duplicate()
	
	score = checkpoint_data["score"]
	stability_points = checkpoint_data["stability_points"]
	chaos_points = checkpoint_data["chaos_points"]
	
	emit_signal("instability_changed", instability)
	emit_signal("echo_changed", echo_active)
	emit_signal("past_status_changed", past_life, past_energy)
	emit_signal("future_status_changed", future_energy, future_stability)
	emit_signal("inventory_changed")
	emit_signal("score_changed", score, stability_points, chaos_points)

#Feedback Visual do Salvamento do CheckPoint
func show_checkpoint_feedback():
	$CheckpointLabel.text = "Checkpoint salvo!"
	$CheckpointLabel.visible = true
	
	await get_tree().create_timer(2).timeout
	$CheckpointLabel.visible = false

#Reset do Nível
func reset_level():
	instability = 0
	echo_active = false
	
	past_life = 100
	past_energy = 100
	
	future_energy = 100
	future_stability = 100
	
	past_inventory.clear()
	future_inventory.clear()
	
	reset_to_level_score()
	
	emit_signal("instability_changed", instability)
	emit_signal("echo_changed", echo_active)
	emit_signal("past_status_changed", past_life, past_energy)
	emit_signal("future_status_changed", future_energy, future_stability)
	emit_signal("inventory_changed")
	
#Reset Geral
func reset_game():
	reset_level()
	
	score = 0
	stability_points = 0
	chaos_points = 0
	
	level_start_score = 0
	level_start_stability_points = 0
	level_start_chaos_points = 0
	
	emit_signal("score_changed", score, stability_points, chaos_points)
