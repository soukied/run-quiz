class_name Spike extends Node

@onready var parent : Enemy = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.on_slashed.connect(on_slashed)
	parent.on_hit.connect(on_hit)
	#pass # Replace with function body.

func on_slashed(_player: Player):
	pass
	
func on_hit(player: Player):
	player.health -= 1
