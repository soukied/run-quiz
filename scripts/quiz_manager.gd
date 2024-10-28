extends Node

signal success
signal problem(err)

var quiz_topic : String = "Pengetahuan Umum"
# Called when the node enters the scene tree for the first time.
var quiz_list : Array[Quiz] = []
var requesting = false
#func _ready():
	#pass # Replace with function body.
var llm_request : LLMRequest = LLMRequest.new("https://api.groq.com/openai/v1/chat/completions","llama-3.1-70b-versatile")

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(llm_request)
	llm_request.result.connect(new_quiz)
	llm_request.error.connect(failed_request)
	#llm_request.send(quiz)

func pop_quiz() -> Quiz:
	var quiz = quiz_list.pop_front()
	return quiz

func quiz_size() -> int:
	return quiz_list.size()

func set_topic(topic: String):
	quiz_topic = topic
	
func get_topic() -> String:
	return quiz_topic
	
func clear_quizzes():
	quiz_list = []	

func new_quiz(a: Array[Quiz]):
	requesting = false
	var size_quiz : int = a.size()
	if size_quiz > 0:
		print( str(a.size())+ " new " + quiz_topic+ " quiz has been added.")
		quiz_list.append_array(a)
		success.emit()
	else:
		problem.emit("Questions has no answer")

func failed_request(result, response_code, headers, body):
	requesting = false
	problem.emit(response_code)

func request_quizes():
	if requesting:
		return
	requesting = true
	print("Requesting " + quiz_topic + " quizzes.")
	llm_request.send(quiz_topic)
