class_name PauseMenu extends CanvasLayer

signal resume

@onready var timer : NTimer = get_tree().get_first_node_in_group("timer")

var shown:= false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Pop in animation
	if timer:
		timer.enabled = false
	pop_in()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pop_in():
	%PausePanel.position.y = 1111
	var tw:=get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(%PausePanel, "position:y", 182, 1.0 / 4.0)
	await tw.finished
	shown = true
static func create(parent:Node) -> PauseMenu:
	var pause_scene : PackedScene = preload("res://scene/pause_screen.tscn")
	var pause_inst : PauseMenu = pause_scene.instantiate()
	parent.add_child(pause_inst)
	return pause_inst

func pop_out():
	var tw:=get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(%PausePanel, "position:y", 1111, 1.0 / 4.0)
	await tw.finished

func resume_game() -> void:
	# Pop out
	await pop_out()
	resume.emit() # Replace with function body.
	if timer:
		timer.enabled = true
	self.queue_free()


func retry() -> void:
	await pop_out()
	GameManager.clear_player()
	QuizManager.clear_quizzes()
	QuizManager.request_quizes()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/runner_scene.tscn")

func main_menu() -> void:
	await pop_out()
	GameManager.clear_player()
	QuizManager.clear_quizzes()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")

var closing:= false
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if closing or !shown:
			return
		closing = true
		resume_game()
