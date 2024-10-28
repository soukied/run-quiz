class_name LevelupChoice extends CanvasLayer

var health_scene = preload("res://scene/items/health.tscn")
var shield_scene = preload("res://scene/items/shield.tscn")
var jumpboost_scene = preload("res://scene/items/jumpboost.tscn")
var coinmult_scene = preload("res://scene/items/coinmult.tscn")
var maxhealth_scene = preload("res://scene/items/maxhealth.tscn")
signal result(res: LevelupResult)

@onready var item_selections : Array[TextureButton] = [%ItemSelect1, %ItemSelect2, %ItemSelect3]
@onready var player: Player = GameManager.get_player()
@onready var world : World = GameManager.get_world()
@onready var quiz_btn : Button = %QuizBtn
@onready var coint_btn : Button = %CoinTradeBtn
#@onready var player : Player = GameManager.get_player()
var cost := 5


var selected_item : Item = null
var type: Type
# Called when the node enters the scene tree for the first time.
enum Type {
	QUIZ,
	COIN
}

func _ready():
	quiz_btn.pressed.connect(select_quiz)
	coint_btn.pressed.connect(select_coin_trade)
	close_buttons()
	hide_item_selections()
	remove_selected()

	if player:
		cost += player.level - 1
	
	coint_btn.text = "Lewati Kuis\n(-%s Koin)" % str(cost)

	var items_scenes: Array[PackedScene] = [
		health_scene,
		shield_scene, 
		jumpboost_scene,
		coinmult_scene,
		maxhealth_scene
	]

	items_scenes.shuffle()
	var item_choices : Array[Item] = []

	for i:PackedScene in items_scenes:
		var inst: Item = i.instantiate()
		if player and player.has_effect(inst.type):
			continue
		item_choices.append(inst)

	for j : int in range(item_choices.size()):
		if j == 3: break
		var item : Item = item_choices[j]
		var btn : TextureButton = item_selections[j]
		btn.texture_normal = item.texture
		btn.visible = true
		btn.pressed.connect(press_item.bind(btn, item)) # Replace with function body.

func remove_selected():
	for btn: TextureButton in item_selections:
		btn.modulate = Color(0.45, 0.45, 0.45, 1.0)

func press_item(btn: TextureButton, item: Item):
	remove_selected()
	%ItemPickAudio.play()
	btn.modulate = Color(1, 1, 1, 1)
	self.selected_item = item
	show_buttons()

func hide_item_selections():
	for h : TextureButton in item_selections:
		h.visible = false

func show_buttons():
	quiz_btn.disabled = false
	if player and player.coin >= cost:
		coint_btn.disabled = false
	
func close_buttons():
	quiz_btn.disabled = true
	coint_btn.disabled = true

func select_coin_trade():
	type = Type.COIN
	player.coin -= 5
	close()

func select_quiz():
	type = Type.QUIZ
	close()

func close():
	result.emit(LevelupResult.new(selected_item, type))
	queue_free()

static func create(parent: Node) -> LevelupChoice:
	var scene = load("res://scene/levelup_choice.tscn")
	var inst: LevelupChoice = scene.instantiate()
	parent.add_child(inst)
	return inst

class LevelupResult:
	var item : Item = null
	var type : Type
	func _init(_item, _type):
		self.item = _item
		self.type = _type