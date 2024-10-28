class_name GPTRequest extends HTTPRequest

signal error(result, response_code, headers, body)
signal result(quizzes:Array[Quiz])

const URL = "https://opengpts-example-vz4y4ooboq-uc.a.run.app/runs/stream"
var _header : Array[String] = []
var regex_opt1: RegEx
var regex_opt2: RegEx

# Called when the node enters the scene tree for the first time.
func _init():
	regex_opt1 = RegEx.new()
	regex_opt1.compile("^(A|B|C|D)\\. ")
	regex_opt2 = RegEx.new()
	regex_opt2.compile("^\\#(A|B|C|D)\\. ")
	use_threads = true
	request_completed.connect(receive)
	get_headers()

func get_randid() -> String:
	var characters := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"
	var result := ""
	var size = characters.length()
	for i in range(36):
		result += characters[randi_range(0, size - 1)]
	return result
	
func get_headers() -> void:
	add_header("authority", "opengpts-example-vz4y4ooboq-uc.a.run.app")
	add_header("accept", "text/event-stream")
	add_header("accept-language", "en-US,en;q=0.7")
	add_header("cache-control", "no-cache")
	add_header("content-type", "application/json")
	add_header("cookie", "opengpts_user_id="+get_randid())
	add_header("origin", "https://opengpts-example-vz4y4ooboq-uc.a.run.app")
	add_header("pragma", "no-cache")
	add_header("referer", "https://opengpts-example-vz4y4ooboq-uc.a.run.app/")
	add_header("sec-fetch-site", "same-origin")
	add_header("sec-gpc", "1")
	add_header("user-agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")

func add_header(type: String, val: String) -> void:
	_header.push_front("%s: %s" % [type, val])

func get_body(topic:String="Sistem Basis Data") -> String:
	var s = "Generate 10 quiz-like questions covering topics about '%s'. Each question should have 4 options, with only one option being factually correct. Please include a wide variety of difficulty to avoid repetitive and mundane outcome. Format each question as follows: 'Question?|Option1|Option2|#Option3|Option4'. Ensure the correct answer is marked with a '#' symbol. Translate the questions and answers into Bahasa Indonesia. Again, make sure the correct answer from each questions in factually true. I want you to think about it thoroughly." % topic.to_lower()
	return """ 
	{
	"input": [
		{
			"content": "%s",
			"additional_kwargs": {},
			"type": "human",
			"example": false
		}
	],
	"assistant_id": "bca37014-6f97-4f2b-8928-81ea8d478d88",
	"thread_id": ""
}
	""" % s# "Write me 10 quizzes about Sistem Basis Data.\\nOne quiz have 4 options with only one answer indicated by # sign.\\nWrite the response in Bahasa Indonesia.\\nExample Response:\\nWho invented airplane?|Alexander Graham Bell|Alan Turing|#Wright Brothers|Nikola Tesla\\nWhen is USA Independence Day celebrated?|#July 4th|August 17th|May 4th|December 25th\\n"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func send(topic: String):
	self.request(URL, _header ,HTTPClient.METHOD_POST, get_body(topic))

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
			print(q_opts)
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
		#print(data)
		var data_arr = data.split("event: data")
		#print(data.split("\n\n"))
		var res = data_arr[data_arr.size() - 2].strip_edges().substr(6)
		var s = JSON.parse_string(res)
		var cont = s[1]["content"].split("\n")
		var regex = RegEx.new()
		regex.compile("^\\d+\\. ")
		for i in range(cont.size()):
			cont[i] = regex.sub(cont[i], "")
			#print(cont[i])
		var quizzes = process_data(cont)
		if quizzes.size() > 0:
			self.result.emit(quizzes)
		else:
			error.emit(result, response_code, headers, body)
	else:
		#print("Error")
		error.emit(result, response_code, headers, body)
