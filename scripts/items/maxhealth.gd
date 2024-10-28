extends Node

@onready var parent: Item = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	#if not parent.on_recieve.is_connected(on_recieve):
	parent.on_recieve.connect(on_recieve)
#	pass # Replace with function body.

func on_recieve(player: Player):
	player.max_health += 1
