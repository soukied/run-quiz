class_name JumpBoostEffect extends Node

const timer : int = 15
const type : Item.Type = Item.Type.JUMP_BOOST
@onready var parent : Player = self.get_parent() as Player

func _ready():
	tick = timer as float
	parent.add_effect(type)
	parent.jump_boost_max = 2
	if !parent.is_on_floor():
		parent.jump_boost += 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
var tick := 15.0

func _process(delta):
	parent.effects_durations[type] = tick
	if tick <= 0:
		parent.jump_boost_max = 1
		parent.remove_effect(type)
		queue_free()
		return	
	tick -= delta
