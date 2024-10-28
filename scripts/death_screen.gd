extends CanvasLayer

signal retry_pressed
signal main_menu_pressed

@onready var anim : NTimer = get_tree().get_first_node_in_group("timer")

var shown:= false

func pop(score: int, level: int, subject: String):
	self.visible = true
	pop_in()
	set_stat(score, level, subject)
	
func set_stat(score:int, level:int, subject:String):
	%SubjectLabel.text = "\"" +  subject + "\""
	%StatLabel.text = "Level: " + str(level) + "\n"
	%StatLabel.text += "Skor: " + str(score)
	
func pop_in():
	var y:= 1107
	%PanelContainer.position.y = y
	var tw:=get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(%PanelContainer, "position:y", 123, 0.3)
	await tw.finished
	shown = true

func retry_btn():
	retry_pressed.emit()


func main_menu_btn():
	main_menu_pressed.emit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and shown and get_tree().paused:
		main_menu_btn()
