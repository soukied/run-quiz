class_name Alert extends CanvasLayer

signal closed
signal result(answer:bool)

var type : Type = Type.DEFAULT
var answer := true

const NORMAL_HEIGHT := 388
const HIDDEN_HEIGHT := 1102

enum Type {
	DEFAULT,
	CONFIRMATION
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pop_in()
	
func pop_in() -> void:
	%PromptContainer.position.y = HIDDEN_HEIGHT
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(%PromptContainer, "position:y", NORMAL_HEIGHT , 0.2)

func pop_out() -> void:
	%PromptContainer.position.y = NORMAL_HEIGHT
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	await tw.tween_property(%PromptContainer, "position:y", HIDDEN_HEIGHT, 0.2).finished
	result.emit(answer)
	closed.emit()
	self.queue_free()

func set_alert(text: String, prompt_type: Type) -> void:
	%PromptText.text = text
	if prompt_type == Type.DEFAULT:
		%BtnAnchor1.visible = false

func confirm_pressed() -> void:
	answer = true
	pop_out()

func close_pressed() -> void:
	answer = false
	pop_out()
	
static func create(parent: Node, text: String, type: Type = Type.DEFAULT) -> Alert:
	var scene: PackedScene = load("res://scene/alert.tscn")
	var scene_inst : Alert = scene.instantiate()
	scene_inst.set_alert(text, type)
	parent.add_child(scene_inst)
	return scene_inst
