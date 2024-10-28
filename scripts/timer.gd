class_name NTimer extends Node

var time : float = 0.0
var enabled : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !enabled:
		return
	time += delta
