extends Node

@onready var parent: Item = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.on_recieve.connect(on_recieve)
#	pass # Replace with function body.

func on_recieve(player: Player):
	player.health += 1
