extends Node2D

func _process(_delta):
	if self.position.x < -100:
		self.queue_free()

func area_entered(area:Area2D):
	if area.is_in_group("player_area"):
		var player : Player = area.get_parent()
		player.health -= 1
		self.queue_free()
