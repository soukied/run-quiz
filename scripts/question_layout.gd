class_name QuestionLayout extends CanvasLayer

signal answer(val: bool)

@onready var buttons: Array[Button] = [%Option0, %Option1, %Option2, %Option3]
@export var enable_timer : bool = true
@export var timer : int = 15

@onready var player : Player = get_tree().get_first_node_in_group("player")

var correct_theme : Theme = preload("res://themes/correct_answer.tres")
var wrong_theme : Theme = preload("res://themes/wrong_answer.tres")
var world : World
#static var is_showing = falses
#static var cur_question : QuestionLayout = null
var quiz : Quiz = null
var quiz_answered = false
# Called when the node enters the scene tree for the first time.
var cur_time : float = timer as float

func play_audio(type:String):
	match type:
		"correct":
			%CorrectAudio.play()
		"incorrect":
			%IncorrectAudio.play()

func _ready():
	get_tree().paused = true
	pop_panel()
	world = GameManager.get_world()
	if !quiz:
		quiz = Quiz.new("1 + 1 = ?", [
			["2", true],
			["3", false],
			["4", false],
			["5", false]
		])
		quiz.shuffle_options()
	
	%Label.text = quiz.question
	#%AnimationPlayer.play("popup")
	print(quiz.options)
	for i in range(buttons.size()):
		var button = buttons[i]
		button.text = quiz.options[i][0]
		var ans = quiz.options[i][1]
		if ans:
			button.pressed.connect(correct_answer.bind(button))
			continue
		button.pressed.connect(wrong_answer.bind(button))

func pop_panel():
	var quiz_cont: PanelContainer = $QuizContainer
	var final_pos := quiz_cont.position.y
	quiz_cont.position.y = 1093
	print(quiz_cont)
	var tw1 := get_tree().create_tween()
	tw1.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw1.tween_property(quiz_cont, "position:y", 123 as float, 0.3)
	
func correct_answer(btn: Button):
	if quiz_answered:
		return
	quiz.show_correct()
	btn.theme = correct_theme
	play_audio("correct")
	#print("Correct Answer")
	player.correct_answer += 1
	#answer.emit(true)
	close(true)
	
func wrong_answer(btn: Button):
	if quiz_answered:
		return
	btn.theme = wrong_theme
	buttons[quiz.show_correct()[0]].theme = correct_theme
	play_audio("incorrect")
	player.incorrect_answer += 1
	#print("Wrong Answer")
	#answer.emit(false)
	close(false)
	
func close(ans: bool):
	quiz_answered = true
	await get_tree().create_timer(2).timeout
	answer.emit(ans)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if quiz_answered:
		return
		
	if enable_timer:
		if cur_time <= 0:
			buttons[quiz.show_correct()[0]].theme = correct_theme
			play_audio("incorrect")
			player.incorrect_answer += 1
			close(false)
			cur_time = 0
		else:
			cur_time -= delta
			cur_time = clampf(cur_time, 0.0, 999999.0)
		
	#print(cur_time)
	%TimerLabel.text = str(ceil(cur_time))

func set_quiz(q:Quiz):
	self.quiz = q

static func create(parent: Node, quiz: Quiz , timer: int = 15) -> QuestionLayout:
	var scene = load("res://scene/question_layout.tscn")
	var inst: QuestionLayout = scene.instantiate()
	inst.set_quiz(quiz)
	#cur_question = inst
	parent.add_child(inst)
	return inst
