extends CanvasLayer
#ADICIONAR ESSA LINHA NAS AÇÕES DOS PLAYERS PARA A BARRA DE INSTABILIDADE
#Global.add_instability(5)
#ADICIONAR ESSA LINHA NAS AÇÕES DOS PLAYERS PARA O SIMBOLO ALERTA APARECER E DESAPARECER
#Global.set_echo(true)
#ADICIONAR ESSA LINHA NAS AÇÕES DOS PLAYERS PARA ATUALIZAR ENERGIA, ESTABILIDADE E VIDA
#Global.update_past(-1, -1)
#Global.update_future(-1, -1)
#ADICIONAR ESSA LINHA NAS AÇÕES DOS PLAYERS PARA INCLUIR ITENS AO INVENTÁRIO
#Global.add_item("past", "wood", 3)
#Global.add_item("future", "energy_cell", 2)
#ADICIONAR ESSAS LINHAS NAS AÇÕES DOS PLAYERS PARA CONTABILIZAR OS PONTOS
#Global.add_stability_points(10)
#Global.add_chaos_points(10)
#ADICIONAR ESSAS LINHAS NAS AÇÕES DOS PLAYERS PARA SALVAR CHECKPOINT
#Global.save_checkpoint()
#ADICIONAR ESSAS LINHAS QUANDO O PLAYER MORRE
#Global.load_checkpoint()
#get_tree().reload_current_scene()

signal start_game

@onready var instability_bar = $InstabilityBar
@onready var instability_label = $InstabilityBar/InstabilityLabel
@onready var echo_indicator = $EchoIndicator

@onready var echo_sound = $EchoIndicator/SoundEcho
var sound_on = true

#@onready var pegarItem = $PegarItem
#var pegarItemTimer : Timer
#var showed_inventory_pegarItem = false

@onready var past_life_bar = $PlayerPastUI/EnergyBar
@onready var past_grid = $PastInventory/GridContainer

@onready var future_energy_bar = $PlayerFutureUI/EnergyBar
@onready var future_grid = $FutureInventory/GridContainer

@onready var total_score_label = $ScoreUI/TotalLabel
@onready var stability_label = $ScoreUI/StabilityLabel
@onready var chaos_label = $ScoreUI/ChaosLabel

var instability = 100
var echo_active = false


func _ready() -> void:
	Global.instability_changed.connect(set_instability)
	Global.echo_changed.connect(set_echo)
	Global.past_status_changed.connect(update_past_ui)
	Global.future_status_changed.connect(update_future_ui)
	Global.inventory_changed.connect(update_inventory_ui)
	Global.score_changed.connect(update_score_ui)
	
	#Mensagens temporárias
	#pegarItemTimer = Timer.new()
	#pegarItemTimer.one_shot = true
	#add_child(pegarItemTimer)
	#pegarItemTimer.timeout.connect(_on_hint_timeout)
	
	update_ui()
	pass 

func _process(delta: float) -> void:
	#Adiciona Glitch na barra de instabilidade
	if instability > 70:
		$InstabilityBar.position.x += randf_range(-1, 1)
	# Efeito piscando ECO
	if echo_active:
		var time = Time.get_ticks_msec() / 1000.0
		# Opacidade (fade)
		echo_indicator.modulate.a = 0.6 + sin(time * 6) * 0.4
		# Escala (respiração/glitch)
		var scale_glitch = 1.0 + sin(time * 8) * 0.05
		echo_indicator.scale = Vector2(scale_glitch, scale_glitch)
		
#ECO Ativo
func set_echo(state):
	echo_active = state
	echo_indicator.visible = state
	
	if state and sound_on:
		echo_sound.play()
	else:
		echo_sound.stop()

#Medicao de Instabilidade Temporal
func set_instability(value):
	instability = clamp(value, 0, 100)
	update_ui()

func add_instability(value):
	instability = clamp(instability, 0, 100)
	update_ui()

#Atualizar Barra de Instabilidade
func update_ui():
	instability_bar.value = instability
	instability_label.text = "Instabilidade: %d%%" % instability
	
	if instability < 30:
		instability_bar.modulate = Color.GREEN
		Global.set_echo(false)
	elif instability < 70:
		instability_bar.modulate = Color.YELLOW
		Global.set_echo(true)
	else:
		instability_bar.modulate = Color.RED
		Global.set_echo(false)
		$EchoIndicator.visible = false
		

#Atualizar barras dos Personagens
func update_past_ui(life, energy):
	past_life_bar.value = life
	
func update_future_ui(energy, stability):
	future_energy_bar.value = energy
	
#Atualiza Inventário
func update_inventory_ui():
	clear_grid(past_grid)
	clear_grid(future_grid)
	
	for item in Global.past_inventory:
		add_item_to_grid(past_grid, item, Global.past_inventory[item])
	
	for item in Global.future_inventory:
		add_item_to_grid(future_grid, item, Global.future_inventory[item])
	
	#if not showed_inventory_pegarItem:
		#show_message("Clique em um item do inventário para utilizá-lo", 4)
		#showed_inventory_pegarItem = true

#Limpa Inventário
func clear_grid(grid):
	for child in grid.get_children():
		child.queue_free()

#Cria item visual dentro do Inventário
func add_item_to_grid(grid, item, amount):
	var slot = TextureRect.new()
	slot.texture = load(get_item_texture(item))
	slot.custom_minimum_size = Vector2(32, 32)
	
	var label = Label.new()
	label.text = str(amount)
	
	var container = VBoxContainer.new()
	container.add_child(slot)
	container.add_child(label)
	
	grid.add_child(container)

#Mapeia Texturas dos Objetos do Inventário
func get_item_texture(item):
	match item:
		"wood":
			return "res://sprites/enemyFlyingAlt_1.png"
		"stone":
			return "res://sprites/enemyFlyingAlt_2.png"
		"energy_cell":
			return "res://sprites/playerGrey_up1.png"
		"fragment":
			return "res://sprites/playerGrey_walk1.png"
		_:
			return "res://sprites/playerGrey_up2.png"
			
#ATUALIZA PONTUAÇÃO
func update_score_ui(total, stability, chaos):
	total_score_label.text = "SCORE: %d" % total
	stability_label.text = "ESTABILIDADE: %d" % stability
	chaos_label.text = "CAOS: %d" % chaos

#Mensagens Temporarias
#func show_message(text: String, duration: float = 3.0):
	#pegarItem.text = text
	#pegarItem.visible = true
	
	#pegarItemTimer.start(duration)

#func _on_hint_timeout():
	#pegarItem.visible = false

#Conexao Botao de SoundOff
func _on_sound_off_pressed() -> void:
	sound_on = false
	$SoundOn/SoundPlay.stop()
	$EchoIndicator/SoundEcho.stop()
	$SoundOff.visible = false
	$SoundOn.visible = true

#Conexao Botao de SoundOn
func _on_sound_on_pressed() -> void:
	sound_on = true
	$SoundOn/SoundPlay.play()
	$EchoIndicator/SoundEcho.play()
	$SoundOn.visible = false
	$SoundOff.visible = true

#Botão de Reset
func _on_reset_button_pressed() -> void:
	await get_tree().create_timer(0.3).timeout
	Global.reset_game()
	get_tree().reload_current_scene()
