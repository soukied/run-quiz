class_name Mushroom extends Node

var parent: Enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	parent.on_hit.connect(on_hit)
	parent.on_slashed.connect(on_slashed)
	

func on_hit(player: Player):
	if !parent.dead:
		player.health -= 1

func on_slashed(player: Player):
	if parent.dead:
		player.score += 2
		player.coin += 2 * player.coin_multiplier
		player.health -= 1
	#parent.queue_free()