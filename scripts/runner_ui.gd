class_name RunnerUI extends CanvasLayer

@onready var player : Player = GameManager.get_player()
# Called when the node enters the scene tree for the first time.
var max_health : int
var health: int
func _ready():
	hide_effects()
	GameManager.player_set.connect(link_signal)
	if player:
		link_signal(player)
	#pass # Replace with function body.

func link_signal(player):
	self.player = player
	%HealthBar.max_value = player.max_health
	self.max_health = player.max_health
	self.health = player.health
	%HealthBar.value = player.health
	coin_change(player.coin)
	level_change(player.level)
	change_health_label()
	player.max_health_changed.connect(max_health_change)
	player.health_changed.connect(health_change)
	player.score_changed.connect(score_change)
	player.level_changed.connect(level_change)
	player.coin_changed.connect(coin_change)
	player.effect_changed.connect(effects_change)
	
func set_player_pos(_player: Player):
	var player_pos = _player.position
	#$VBoxContainer/PlayerPos.text = "X: " + str(round(player_pos.x)) + ", Y: " + str(round(player_pos.y))
# Called every frame. 'delta' is the elapsed time since the previous frame.

func coin_change(coin):
	print("Coin added")
	%CoinLabel.text = " x " + str(coin)

func level_change(l:int):
	%LevelLabel.text = "Level: " + str(l)

func score_change(a:int):
	%ScoreLabel.text = "Skor : " + str(a)

func health_change(val: int):
	self.health = val
	change_health_label()
	print("Health changed to " + str(val))
	
func max_health_change(val: int):
	self.max_health = val
	change_health_label()
	print("Max health changed to " + str(val))

func change_health_label():
	%HealthLabel.text = str(self.health) + " / " + str(self.max_health)
	%HealthBar.max_value = self.max_health
	%HealthBar.value = self.health

func hide_effects():
	for i: Node in %PlayerEffects.get_children():
		i.visible = false

func effects_change(effects: Array[Item.Type]):
	hide_effects()
	for type:Item.Type in effects:	
		match type:
			Item.Type.COIN_MULTIPLIER:
				%CoinMultEffect.get_parent().visible = true
			Item.Type.JUMP_BOOST:
				%JumpBoostEffect.get_parent().visible = true
			Item.Type.SHIELD:
				%ShieldEffect.get_parent().visible = true
			
func _process(delta: float) -> void:
	if !player:
		return
	%JumpBoostEffect.get_parent().get_node("Timeout").text = str(player.effects_durations[Item.Type.JUMP_BOOST]).pad_decimals(1)
	%ShieldEffect.get_parent().get_node("Timeout").text = str(player.effects_durations[Item.Type.SHIELD]).pad_decimals(1)
	%CoinMultEffect.get_parent().get_node("Timeout").text = str(player.effects_durations[Item.Type.COIN_MULTIPLIER]).pad_decimals(1)
	
func on_jump():
	if player:
		player.jump()
	#pass # Replace with function body.


func on_attack():
	if player:
		player.start_slashing()


func pause_game() -> void:
	if get_tree().paused or player.is_dead:
		return
	get_tree().paused = true
	await PauseMenu.create(get_tree().current_scene).resume
	get_tree().paused = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		pause_game()
