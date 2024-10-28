class_name Necromancer extends Node

var anim_sprite : AnimatedSprite2D
var fireball_scene = preload("res://scene/fireball.tscn")
@export var attack_timeout := 1.0
@onready var parent: Enemy = self.get_parent()
@onready var player: Player = GameManager.get_player()
# Called when the node enters the scene tree for the first time.
func _ready():
	parent.on_slashed.connect(slash)
	parent.on_hit.connect(hit_player)
	anim_sprite = parent.get_node("Sprite")
	anim_sprite.frame_changed.connect(frame_change)
	
func hit_player(player: Player):
	print("Hit player")
	if player and !parent.dead:
		player.health -= 1 
	
func slash(player: Player):
	if parent.dead:
		player.score += 1
		player.coin += 1 * player.coin_multiplier
	
func launch_spell():
	print("Neromance Attack")
	var world : World = GameManager.get_world()
	if world:
		var pos = Vector2(-92, -72) + parent.position
		var fireball_inst : Node2D = fireball_scene.instantiate()
		fireball_inst.position = pos
		world.add_child(fireball_inst)
	
func frame_change():
	if anim_sprite.frame == 30:
		launch_spell()
		
func on_animation_finish() -> void:
	var s :AnimatedSprite2D = self.get_parent().get_node("Sprite")
	await get_tree().create_timer(attack_timeout).timeout
	s.play("attack")
