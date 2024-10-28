class_name LLMRequest extends HTTPRequest

signal error(result, response_code, headers, body)
signal result(quizzes:Array[Quiz])

const API_KEY = "Z3NrX3dINHhIWUxNTDVCRWN6ak9JNVdVV0dkeWIzRll1ckZlclo5VUh0QjdHUEhOV0xVaHhsZkk="
const URL = "https://api.openai.com/v1/chat/completions"
const MODEL = "gpt-3.5-turbo"
var _header : Array[String] = []
var regex_opt1: RegEx
var regex_opt2: RegEx

var custom_endpoint: String = ""
var custom_model : String = ""

# Called when the node enters the scene tree for the first time.
func _init(endpoint : String = "", model: String = ""):
	self.custom_endpoint = endpoint
	self.custom_model = model
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.timeout = 5.0
	regex_opt1 = RegEx.new()
	regex_opt1.compile("^(A|B|C|D)\\. ")
	regex_opt2 = RegEx.new()
	regex_opt2.compile("^\\#(A|B|C|D)\\. ")
	use_threads = true
	request_completed.connect(receive)
	get_headers()
	
func get_headers() -> void:
	add_header("Content-Type", "application/json")
	add_header("Authorization", "Bearer " + Marshalls.base64_to_utf8(API_KEY))


func add_header(type: String, val: String) -> void:
	_header.push_front("%s: %s" % [type, val])

func get_body(topic:String="Pengetahuan Umum") -> String:
	return """ 
		{
		  "messages": [
				{
					"role": "system",
					"content": "You are a helpful assistant that generate certain number of quiz questions based on a topic in given format without comments and translate it into Indonesian. Again, there should be no notes or commentary in response. For example, I want you to generate 1 quiz questions you will response with this format: \\n\\n<Question>|<Option 1>|#<Option 2 is correct>|<Option 3>|<Option4>"
				},
				{
					"role": "user",
					"content": "Generate 2 quiz questions about 'Penemuan'."
				},
				{
					"role":"assistant",
					"content": "Siapakah yang bertanggung jawab atas terciptanya telepon?|Thomas Edison|#Alexander Graham Bell|Benjamin Franklin\\nProtokol apa yang diciptakan oleh Tim Berners-Lee?|#Hypertext Transfer Protocool (HTTP)|Internet Protocol (IP)|Domain Name System (DNS)|Web Browser"
				},
				{
					"role": "user",
					"content": "Generate 10 quiz questions about '%s'."
				}
		  ],
		  "model": "%s"
		}
	""" % [topic.to_lower().replace("\"", "\\\""), MODEL if custom_model == "" else custom_model]
	
func send(topic: String):
	self.request(URL if custom_endpoint == "" else custom_endpoint , _header ,HTTPClient.METHOD_POST, get_body(topic))

func process_data(data: PackedStringArray) -> Array[Quiz]:
	var res : Array[Quiz] = []
	for i in range(data.size()):
		var rdata = data[i]
		var quiz_data = rdata.split("|")
		var question = quiz_data[0]
		var opts : Array[Array] = []
		if quiz_data.size() != 5:
			continue
		var has_correct_answer = false
		for j in range(1, 5):
			var q_opts = quiz_data[j]
			q_opts = regex_opt1.sub(q_opts, "")
			q_opts = regex_opt2.sub(q_opts, "#")
			# Prevent game from crash when q_opts type isn't string.
			#print(q_opts)
			if typeof(q_opts) != TYPE_STRING:
				continue
			if q_opts[0] == "#":
				has_correct_answer = true
				opts.append([q_opts.substr(1), true])
			else:
				opts.append([q_opts, false])
		opts.shuffle()
		if has_correct_answer:
			res.push_front(Quiz.new(question, opts))
		else:
			print("One quiz has no answer.")
	res.shuffle()
	return res
	
func receive(result, response_code, headers, body):
	#print("GPT Stop Requesting")
	if response_code == 200:
		var data : String = body.get_string_from_utf8()
		var json: JSON = JSON.new()
		#print(data)
		var is_err: int = json.parse(data)
		if is_err != 0:
			error.emit(result, response_code, headers, body)
			return
		var questions_data: String = json.data["choices"][0]["message"]["content"]
		var output: Array[Quiz] = process_data(questions_data.split("\n"))
		if output.size() < 1:
			self.error.emit(result, response_code, headers, body)
			return
		self.result.emit(output)
		for s:Quiz in output:
			print(s.question)
	else:	#print("Error")
		self.error.emit(result, response_code, headers, body)
