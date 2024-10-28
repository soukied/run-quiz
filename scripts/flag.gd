@tool
extends Node2D

@onready var flag_area : Area2D = %Area

func _ready() -> void:
	$Sprite.play("default")

func _process(_delta):
	if Engine.is_editor_hint():
		return
	#if self.position.x < -100:
		#queue_free()

func area_entered(area: Area2D):
	var world : World = GameManager.get_world()
	if area.is_in_group("player_area"):
		print("passed the flag")
		flag_area.queue_free()
		world.level_up()
