extends Node

const savegame_path: String = "user://savegame.json"

var saves: Array[Dictionary] = [
]
# Called when the node enters the scene tree for the first time.
func _ready():
	load_save() # Replace with function body.

func load_save():
	if !FileAccess.file_exists(savegame_path):
		print("No save file.")
		return
	var file = FileAccess.open(savegame_path, FileAccess.READ)
	var data = file.get_as_text()
	var objects: Array = JSON.parse_string(data)
	for obj in objects:
		saves.append(obj)
	#print(saves)

func save():
	var file = FileAccess.open(savegame_path, FileAccess.WRITE)
	var data = JSON.stringify(saves)
	file.store_string(data)
	file.close()
	print("Save file is written")

func add_save(
	subject: String,
	score:int,
	level: int,
	time: float,
	correct_answers: int,
	incorrect_answers: int
	):
	
	saves.push_front({
		"id": gen_uuid(),
		"subject": subject,
		"score": score,
		"level": level,
		"time": time,
		"correct_answers": correct_answers,
		"incorrect_answers": incorrect_answers
	})
	
	print("Add to savefile")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func remove(id:String) -> bool:
	var res = false
	for i in range(saves.size()):
		var s = saves[i]
		if s["id"] == id:
			res = true
			saves.remove_at(i)
			break
	return res

func gen_uuid() -> String:
	var res: String = ""
	const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for _i in range(10):
		res += chars[randi_range(0, chars.length() - 1)]
	return res
