class_name ShieldEffect extends Node

var tick = 15.0
const type : Item.Type = Item.Type.SHIELD
@onready var parent : Player = self.get_parent() as Player

func _ready():
	parent.shielded = true
	parent.show_shield()
	parent.add_effect(type)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parent.effects_durations[type] = tick
	if tick <= 0:
		parent.shielded = false
		parent.remove_effect(type)
		parent.hide_shield()
		queue_free()
		return	
	tick -= delta
