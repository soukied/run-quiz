extends Node2D

@onready var start_game_btn : Button = %StartGameBtn 
@onready var guide_btn : Button = %GuideBtn
@onready var scoreboard_btn : Button = %ScoreboardBtn
@onready var about_btn : Button = %About
# Called when the node enters the scene tree for the first time.
func _ready():
	GameMusic.stop()
	if !MainMenuMusic.playing:
		MainMenuMusic.play()
	start_game_btn.pressed.connect(start_game)
	guide_btn.pressed.connect(show_guide)
	scoreboard_btn.pressed.connect(show_scoreboard)
	about_btn.pressed.connect(show_about)
	
func start_game():
	get_tree().change_scene_to_file("res://scene/subject_select.tscn")

func show_guide():
	get_tree().change_scene_to_file("res://scene/guide.tscn")
	
func show_scoreboard():
	get_tree().change_scene_to_file("res://scene/scoreboard.tscn")
	
func show_about():
	get_tree().change_scene_to_file("res://scene/about.tscn")

var notif_shown := false
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
			if notif_shown:
				return
			notif_shown = true
			var s : bool = await Alert.create(get_tree().current_scene, "Apakah anda ingin keluar permainan?", Alert.Type.CONFIRMATION).result
			if s:
				get_tree().quit()
			notif_shown = false
