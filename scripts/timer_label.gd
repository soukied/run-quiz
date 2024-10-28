extends Label

@onready var timer := get_tree().get_first_node_in_group("timer")
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	if !timer:
		return
	var time: float = timer.time
	var seconds:= 0
	var minutes:= 0
	seconds = floori(time) % 60
	minutes = floori(time/60)
	self.text = str(minutes) + ":" + str(seconds)
