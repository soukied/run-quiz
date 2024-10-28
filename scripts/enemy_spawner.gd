extends Node

const necromancer_scene: PackedScene = preload("res://scene/enemies/necromancer.tscn")
const mushroom_scene : PackedScene = preload("res://scene/enemies/mushroom.tscn")
const bat_scene : PackedScene = preload("res://scene/enemies/bat.tscn")
const spike_scene : PackedScene = preload("res://scene/enemies/spike.tscn")
const flag_scene : PackedScene = preload("res://scene/flag.tscn")

@export var enabled : bool = true

@export var base_spawn_interval:float = 3.0
@export var base_spawn_interval_max:float = 5.0
@onready var spawn_interval: float = base_spawn_interval
@onready var spawn_interval_max: float = base_spawn_interval_max

@export var flag_time : int = 6

@onready var player : Player = GameManager.get_player()
var cur_time: float = 3.0
var interval:float = 0.0

var flag_count: int = 0

func _ready():
	cur_time = spawn_interval
	interval = spawn_interval
	GameManager.player_set.connect(player_ready)
	#print(get_viewport().get_visible_rect().size.x)

func player_ready(player: Player):
	self.player = player
	print(player)
	player.level_changed.connect(level_change)

func randomize_interval():
	interval = randf_range(spawn_interval, spawn_interval_max)

func _process(delta):
	if !enabled: 
		return
	if cur_time >= interval:
		if flag_count >= flag_time and QuizManager.quiz_size() > 1:
			spawn_flag()
		else:
			spawn_enemy()
		randomize_interval()
		cur_time = 0
	else:
		cur_time+=delta

func spawn_flag():
	var spawn_point :Vector2 = Vector2(get_viewport().get_visible_rect().size.x + 100, 696)
	var flag_inst := flag_scene.instantiate()
	flag_inst.position = spawn_point
	get_parent().add_child(flag_inst)
	print("Spawn Flag")
	flag_count = 0
	
func spawn_enemy():
	var spawn_point = Vector2(get_viewport().get_visible_rect().size.x + 100, 696)
	var scene_list : Array[PackedScene] = [
		necromancer_scene,
		mushroom_scene,
		bat_scene,
		spike_scene,
	]
	var enemy_scene = scene_list[randi_range(0, scene_list.size() - 1)]
	var enemy_inst: Enemy = enemy_scene.instantiate()
	if enemy_inst.enemy_type == Enemy.Type.Bat:
		spawn_point.y = 416
	elif enemy_inst.enemy_type == Enemy.Type.Spike:
		spawn_point.y = 768
	enemy_inst.position = spawn_point
	get_parent().add_child(enemy_inst)
	flag_count += 1
	print("Flag Count: " + str(flag_count))

func level_change(level:int):
	if level % 3 != 0:
		base_spawn_interval = clampf(base_spawn_interval- 0.2 , 0.8, 100)
		base_spawn_interval_max = clampf(base_spawn_interval_max- 0.2 , 2, 100)