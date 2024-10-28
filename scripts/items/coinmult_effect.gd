class_name CoinMultEffect extends Node


@onready var player : Player = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Coin Mult Picked Up.")
	player.coin_multiplier = 2
	print(player.coin_multiplier)
	player.add_effect(Item.Type.COIN_MULTIPLIER)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var tick : float = 15.0
func _process(delta):
	player.effects_durations[Item.Type.COIN_MULTIPLIER] = tick
	if tick <= 0:
		player.remove_effect(Item.Type.COIN_MULTIPLIER)
		player.coin_multiplier = 1
		tick = 0
		self.queue_free()
	tick -= delta
