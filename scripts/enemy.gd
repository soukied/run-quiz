class_name Enemy extends Node2D

signal on_hit(player)
signal on_slashed(player)

@export var enemy_type : Type

var player : Player
var in_slash_area = false
var dead : bool = false

enum Type {
	Necromancer,
	Knight,
	Mushroom,
	Bat,
	Spike
}

func die():
	dead = true
	$Sprite.speed_scale = 0
	if $AnimationPlayer:
		$AnimationPlayer.play("blink")
	player.enemy_hurt_audio_play()

func _process(_delta):
	player = GameManager.get_player() as Player
	if player and in_slash_area and player.is_slashing() and !dead:
		die()
		on_slashed.emit(GameManager.get_player())
	if position.x < -100:
		queue_free()
		
func on_area_entered(area: Area2D):
	if area.is_in_group("slash_area"):
		in_slash_area = true # Replace with function body.
	elif area.is_in_group("item_area"):
		area.get_parent().position.x += 100
	elif area.is_in_group("player_area"):
		on_hit.emit(GameManager.get_player())

func on_area_exited(area: Area2D):
	if area.is_in_group("slash_area"):
		in_slash_area = false
	#pass # Replace with function body.
