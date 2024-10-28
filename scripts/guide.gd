@tool
class_name Guide extends Node

signal see_changes

@export var image:  Texture2D = null
@export var title: String = ""
@export_multiline var description : String = ""

@export var show_current_guide : bool = false :
    set(val):
        show_current_guide = false
        see_changes.emit()

@export_group("Custom Font", "custom_font_")
## Enable custom font size.
@export var custom_font_enabled : bool = false 
@export var custom_font_size: float = 41