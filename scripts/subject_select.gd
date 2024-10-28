extends Node2D

@onready var input : LineEdit = %SubjectInput
@onready var play_btn : Button = %PlayBtn
@onready var back_btn : Button = %BackBtn

var virtkey_visible := false
var virtkey_height_visible:= 440.0
var virtkey_height_invisible:=1088.0
#var container_height: float
@onready var container_pos :Vector2 = %PanelContainer.position
# Called when the node enters the scene tree for the first time.

var container_height_invisible := 274.0
var container_height_visible := 104.0

func _ready():
	GameMusic.stop()
	if !MainMenuMusic.playing:
		MainMenuMusic.play()
	play_btn.pressed.connect(start_game)
	back_btn.pressed.connect(go_back)

func go_back():
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game():
	var subject : String = input.text.strip_edges()
	if subject == "":
		subject = "Pengetahuan Umum"
	QuizManager.set_topic(subject.replace("\n",""))
	QuizManager.request_quizes()
	get_tree().change_scene_to_file("res://scene/runner_scene.tscn")
	pass # Replace with function body.


func show_virtkey() -> void:
	if virtkey_visible:
		return
	var os_type := OS.get_name()
	if os_type == "Windows" or os_type == "macOS" or os_type == "Linux" or os_type == "Web":
		return
	virtkey_visible = true
	%KeyboardPanel.visible = true
	%KeyboardPanel.position.y = virtkey_height_invisible
	get_tree().create_tween().tween_property(%KeyboardPanel,"position:y", virtkey_height_visible, 0.2)
	get_tree().create_tween().tween_property(%PanelContainer, "position:y", container_height_visible, 0.2)
	pass # Replace with function body.

func close_virtkey():
	if !virtkey_visible:
		return
	virtkey_visible = false
	%KeyboardPanel.visible = true
	%KeyboardPanel.position.y = virtkey_height_visible
	get_tree().create_tween().tween_property(%KeyboardPanel,"position:y", virtkey_height_invisible, 0.2)
	get_tree().create_tween().tween_property(%PanelContainer, "position:y", container_height_invisible, 0.2)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")