extends Node2D

@onready var vbox : VBoxContainer = %SaveList
var saveboard_scene = preload("res://scene/saveboard.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for s in SavegameManager.saves:
		#print(s)
		var saveinst : Saveboard = saveboard_scene.instantiate()
		saveinst.set_save(s)
		vbox.add_child(saveinst)

func go_back():
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vbox.get_children().size() > 0:
		%NoSaveLabel.visible = false
	else:
		%NoSaveLabel.visible = true
		
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")
