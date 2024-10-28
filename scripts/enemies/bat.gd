class_name Bat extends Node

@onready var parent : Enemy = self.get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.on_slashed.connect(on_slashed)
	parent.on_hit.connect(on_hit)
	#pass # Replace with function body.

func on_slashed(player: Player):
	if parent.dead:
		player.score += 1
		player.coin += 1 * player.coin_multiplier
		#parent.queue_free()
	#pass
	
func on_hit(player: Player):
	if !parent.dead:
		player.health -= 1