extends TextureButton

var opacity := 0.7
var _is_pressed:= false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color(1.0, 1.0, 1.0, opacity)
	self.button_down.connect(func(): _is_pressed = true)
	self.button_up.connect(func(): _is_pressed = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_pressed:
		print("Touch Control Pressed!")
		self.modulate = Color(0.62, 0.62, 0.62, opacity)
		return
	self.modulate = Color(1.0, 1.0, 1.0, opacity)