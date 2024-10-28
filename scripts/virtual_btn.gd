class_name VirtkeyButton extends Button

@export var button_type : Type = Type.CharacterButton
@export var line_edit: LineEdit = null 

signal close_virtkey

static var is_upper:= true

var time:=0.0

enum Type {
	CharacterButton,
	SpaceButton,
	BackspaceButton,
	FinishButton,
	ShiftButton
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.button_down.connect(on_press.bind(self.text))
	self.button_up.connect(release_key)
	self.add_to_group("virt_key")
	self.text = self.text.strip_edges()
	if button_type == Type.ShiftButton:
		upper_words()
	#pass # Replace with function body.

func toggle_shift():
	if is_upper:
		lower_words()
		return
	upper_words()

func upper_words():
	if is_upper:
		return
	is_upper = true
	for i:VirtkeyButton in get_tree().get_nodes_in_group("virt_key"):
		if i.button_type == Type.CharacterButton:
			#i.text = i.text.to_upper()
			match(i.text):
				"'":
					i.text = '"'
				_:
					i.text = i.text.to_upper()
	
func lower_words():
	if !is_upper:
		return
	is_upper = false
	for i:VirtkeyButton in get_tree().get_nodes_in_group("virt_key"):
		if i.button_type == Type.CharacterButton:
			#i.text = i.text.to_lower()
			match(i.text):
				'"':
					i.text = "'"
				_:
					i.text = i.text.to_lower()
					
func append_char(char : String):
	if line_edit:
		line_edit.caret_column = 0
		line_edit.text = line_edit.text + char
		line_edit.caret_column = line_edit.text.length()

func delete_char():
	if line_edit:
		line_edit.caret_column = 0
		var text := line_edit.text
		text = text.substr(0, text.length() - 1)
		#line_edit.text = line_edit.text.
		line_edit.text = text
		line_edit.caret_column = text.length()

var pushed := false
func on_press(char: String) -> void:
	pushed = true
	match(button_type):
		Type.CharacterButton:
			append_char(self.text)
			if is_upper:
				lower_words()
		Type.SpaceButton:
			append_char(" ")
		Type.BackspaceButton:
			delete_char()
		Type.ShiftButton:
			toggle_shift()
		Type.FinishButton:
			close_virtkey.emit()
			if line_edit:
				line_edit.release_focus()

func release_key():
	pushed = false
	time = 0.0


func _process(delta: float) -> void:
	if !pushed:
		return
	time += delta
	if time >= 0.5 and button_type == Type.BackspaceButton:
		line_edit.text = ""