class_name World extends Node2D

@export var base_player_speed : float = 500.0
@export var fireball_speed : int = 80
@onready var bg_offset = Vector2(0, 0) 
@onready var player : Player = %Player
@onready var player_speed : float = base_player_speed
# Called when the node enters the scene tree for the first time.
func _ready():
	QuizManager.request_quizes()
	MainMenuMusic.stop()
	GameMusic.play()
	GameManager.set_world(self)
	GameManager.set_player(player)
	#QuizManager.problem.connect(quiz_request_failed)
	player.level_changed.connect(level_change)
	change_player_speed()
	
func change_player_speed():
	for node:Parallax2D in %Background.get_children():
		node.autoscroll = Vector2(-player_speed, 0) * node.scroll_scale

func show_death_screen(score: int, level: int, subject:String):
	%DeathScreen.visible = true
	%DeathScreen.pop(score, level, subject)
	%DeathScreen.retry_pressed.connect(retry)
	%DeathScreen.main_menu_pressed.connect(main_menu)

func retry():
	GameManager.clear_player()
	QuizManager.request_quizes()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/runner_scene.tscn")

func main_menu():
	GameManager.clear_player()
	QuizManager.clear_quizzes()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")

func level_change(level:int):
	print("Level up!")
	if level % 2 == 0:
		player_speed += 80
		player_speed = clampf(player_speed, 0, 1000)
	change_player_speed()
	#if level % 2 == 0:  base_player_speed * (30/100 + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_everything(delta)

func show_questions(q: Quiz) -> bool:
	var s = QuestionLayout.create(self, q)
	var ans = await s.answer
	print(ans)
	return ans

func show_item_choice():
	var s = LevelupChoice.create(self)
	var result: LevelupChoice.LevelupResult = await s.result
	print(result)
	return result

func level_up():
	var quiz : Quiz = QuizManager.pop_quiz()
	var result : bool = true
	
	if !quiz:
		return
	get_tree().paused = true
	var levelup_res: LevelupChoice.LevelupResult = await show_item_choice()
	if levelup_res.type == LevelupChoice.Type.QUIZ:
		result = await show_questions(quiz)
	else:
		pass
	if result:
		give_item_to_player(levelup_res.item)
		player.level += 1
	get_tree().paused = false	

func give_item_to_player(item: Item):
	if item:
		self.add_child(item)
		item.position = player.position

func move_everything(delta):		
	for e : Node2D in get_tree().get_nodes_in_group("entity"):
		e.move_local_x(-player_speed * delta)
		
	for e : Node2D in get_tree().get_nodes_in_group("fireball"):
		e.move_local_x(-(player_speed + fireball_speed) * delta)
		
func spawn_entity(entity: Node):
	entity.position.x = get_viewport_rect().size.x + 100
