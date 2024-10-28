@tool

extends Node2D

@onready var guide_lists := %GuideList.get_children()

var index: int = 0 :
	set(num):
		index = clamp(num, 0, guide_lists.size() - 1)
		if guide_lists.size() > 0:
			update_guide(guide_lists[index], index)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if guide_lists.size() > 0:
		update_guide(guide_lists[index], index)
	for i : int in guide_lists.size():
		var guide: Guide = guide_lists[i]
		guide.see_changes.connect(update_guide.bind(guide, i))

	if Engine.is_editor_hint():
		return

	if !MainMenuMusic.playing:
		MainMenuMusic.play()
	#pass # Replace with function body.

func update_guide(i:Guide, num: int):
	if !i.image:
		%Image.visible = false
	else:
		%Image.visible = true
		%Image.texture = i.image
		
	if i.title.strip_edges() == "":
		%Title.visible = false
	else:
		%Title.visible = true
		%Title.text = i.title

	if i.custom_font_enabled:
		%Description.add_theme_font_size_override("normal_font_size", i.custom_font_size as int)
		%Description.add_theme_font_size_override("bold_font_size", i.custom_font_size as int)
		%Description.add_theme_font_size_override("italics_font_size", i.custom_font_size as int)
		%Description.add_theme_font_size_override("mono_font_size", i.custom_font_size as int)
		%Description.add_theme_font_size_override("bold_italics_font_size", i.custom_font_size as int)

		# print("Custom Font Enabled")
	%Description.text = i.description if i.description != "" else "(Kosong)"

	%GuideIndex.text = str(num + 1) + " / " + str(guide_lists.size())

	%LeftBtn.visible = true
	%RightBtn.visible = true
	if num == 0:
		%LeftBtn.visible = false
	if num == guide_lists.size() - 1:
		%RightBtn.visible = false


func right_btn_pressed() -> void:
	index += 1 # Replace with function body.

func left_btn_pressed() -> void:
	index -= 1 # Replace with function body.

func go_back() -> void:
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn") # Replace with function body.

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")