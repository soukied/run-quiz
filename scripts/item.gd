@tool
class_name Item extends Node

signal on_recieve(player: Player)

#@export_category("Texture Items")
#@export_group("Item")
@export var texture : Texture2D = null
@export var item_name : String = ""
@export var item_description : String = "" 
#@export_category("Item Data")
#@export_group("Item Data")
@export var type : Type = Type.HEALTH
#@export var level : int = 1

var player : Player

enum Type {
	HEALTH,
	MAX_HEALTH,
	ARROW,
	SHIELD,
	COIN_MULTIPLIER,
	JUMP_BOOST
}

func _ready():
	%Sprite.texture = self.texture
	if not Engine.is_editor_hint():
		player = GameManager.get_player()
		
func _process(_delta):
	if self.texture:
		%Sprite.texture = self.texture
	if self.position.x < -100:
		queue_free()

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("player_area"):
		on_recieve.emit(area.get_parent() as Player)
		queue_free()
