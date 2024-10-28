extends Node

var time : float = 0.0
var retry := 0

func _ready() -> void:
	QuizManager.success.connect(success_fetch)
	QuizManager.problem.connect(failed_fetch)
	print("Quiz Fetcher")

func success_fetch():
	retry = 0
	print("Berhasil mengambil data quiz")

func failed_fetch(_err):
	print("Gagal mengambil data quiz, coba lagi...")
	retry += 1
	if retry >= 3:
		get_tree().paused = true
		await Alert.create(get_tree().current_scene, "Gagal mengambil data kuis, pastikan kamu terhubung dengan koneksi internet dan coba lagi!").closed
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")
		return
	QuizManager.request_quizes()

func _process(delta: float) -> void:
	if time >= 5.0:
		if QuizManager.quiz_size() < 5:
			QuizManager.request_quizes()
		time = 0.0
	time += delta
