class_name Quiz extends Node

var question : String = ""
var options : Array[Array] = []
# Called when the node enters the scene tree for the first time.
func _init(q, opts: Array[Array]):
	question = q
	options = opts

func is_option_correct(opt: int):
	return options[opt][1]
	
func shuffle_options():
	options.shuffle()
	
func show_correct() -> Array[int]:
	var res: Array[int] = []
	for s in range(options.size()):
		if options[s][1] == true:
			res.push_back(s)
	return res
	
func show_incorrect() -> Array[int]:
	var incor_list : Array[int] = []
	for i in range(options.size()):
		if not options[i][1]:
			incor_list.push_back(i)
	return incor_list
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
