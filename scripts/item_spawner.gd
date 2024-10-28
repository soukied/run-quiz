extends Node

var health_scene = load("res://scene/items/health.tscn")
var shield_scene = load("res://scene/items/shield.tscn")
var jumpboost_scene = load("res://scene/items/jumpboost.tscn")
@export var enabled: bool = true
@export var spawn_interval:int = 20
@onready var player : Player= GameManager.get_player()

var tick : float = 0.0

func spawn_item():
	var items_scene: Array[PackedScene] = [
		health_scene, 
		shield_scene, 
		jumpboost_scene
	]
	var spawn_point: Vector2 = Vector2(get_viewport().get_visible_rect().size.x + 100, 528)
	var item_inst: Item = items_scene.pick_random().instantiate()
	if player.has_effect(item_inst.type):
		return
	item_inst.position = spawn_point
	self.get_parent().add_child(item_inst)

func _ready():
	GameManager.player_set.connect(_set_player)

func _set_player(_player:Player):
	player = _player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enabled:
		return
	tick += delta
	if tick >= spawn_interval:
		tick = 0
		if player: spawn_item()
