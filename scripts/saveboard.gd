@tool
class_name Saveboard extends Control

var save: Dictionary
var id : String
# Called when the node enters the scene tree for the first time.
func _ready():
	if save:
		id = save["id"]
		%Subject.text = "Materi: " + save["subject"]
		%Score.text = "Skor: " + str(save["score"])
		%Level.text = "Level: " + str(save["level"])
		%Time.text = "Waktu Bermain: "+ time_spent(save["time"])
		%QuizCorrect.text = "Jawab Benar: " + str(save["correct_answers"])
		%QuizIncorrect.text = "Jawab Salah: " + str(save["incorrect_answers"])
		%QuizTotal.text = "Total Jawab: " + str(save["correct_answers"] + save["incorrect_answers"]) 
	#pass # Replace with function body.
	self.custom_minimum_size = self.size

func time_spent(time: float) -> String:
	var ret := ""
	var sec := floori(time) % 60
	var min := floori(time / 60)
	return str(min) + ":" + str(sec)

#func unix2time(utime: float) -> String:
	#var timedict: Dictionary = Time.get_datetime_dict_from_unix_time(utime)
	#var output : String = ""
	#
	#output += str(timedict["hour"]) + ":"
	#output += str(timedict["minute"]) + ":"
	#output += str(timedict["second"]) + " " 
	#
	#output += str(timedict["day"]) + "/"
	#output += str(timedict["month"]) + "/"
	#output += str(timedict["year"])
	#return output

func set_save(s:Dictionary):
	self.save = s
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_btn_pressed():
	var answer = await Alert.create(get_tree().current_scene, "Apakah anda yakin ingin menghapus data pemain?", Alert.Type.CONFIRMATION).result
	
	if !answer:
		return
		
	var res = SavegameManager.remove(id)
	if !res:
		return
	#print("----------")
	#for i in SavegameManager.saves:
		#print(i)
	self.queue_free()
	SavegameManager.save()
