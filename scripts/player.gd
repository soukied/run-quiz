class_name Player extends CharacterBody2D


#@export var texture : Texture2D
#const SPEED = 300.0
signal health_changed(health_val)
signal max_health_changed(max_health_val)
signal score_changed(score)
signal level_changed(lvl)
signal coin_changed(coin)
signal effect_changed(effect: Array[Item.Type])

@export var gravity_enabled : bool = false
@onready var sprite : AnimatedSprite2D = %PlayerSprite
@onready var anim_player : AnimationPlayer = %AnimationPlayer
@onready var timer : NTimer = get_tree().get_first_node_in_group("timer")

const JUMP_VELOCITY = -800.0
var jumping : bool = false

var shielded:bool = false
var jump_boost_max : int = 1
var jump_boost : int = 1

var coin_multiplier : int = 1

var effects: Array[Item.Type] = []
var effects_durations: Dictionary = {
	Item.Type.JUMP_BOOST: 0.0,
	Item.Type.SHIELD: 0.0,
	Item.Type.COIN_MULTIPLIER: 0.0
}
var is_dead: bool = false
var time_playing: float = 0.0

#var quiz_answered : int = 0
var correct_answer : int = 0
var incorrect_answer : int = 0

var level : int = 1 :
	get:
		return level
	set(l):
		level = l
		level_changed.emit(l)
		
@export var coin: int = 0 :
	get:
		return coin
	set(c):
		coin = c
		print(str(coin) + " picked up!")
		coin_changed.emit(coin)
		
var score: int = 0 :
	get:
		return score
	set(s):
		score = s
		score_changed.emit(s)

var max_health :int =  5 :
	set(n):
		n = clamp(n, 1, 100)
		max_health_changed.emit(n)
		var n_health: float = float(health) / float(max_health)
		max_health = n
		print(n_health)
		print(n * n_health)
		health = roundi(n_health * n)
	get:
		return max_health

var health : int = 5 :
	set(n):
		n = clamp(n, 0, max_health)
		if shielded and n < health:
			return
		if n < health:
			%AnimationPlayer.play("blink")
			%HurtAudio.play()
		health = n
		health_changed.emit(health)
		if health == 0:
			dead()
	get:
		return health
		
var slashing = false

func enemy_hurt_audio_play():
	%EnemyHurtAudio.play()

func has_effect(type):
	var i = effects.find(type)
	if i != -1:
		return true
	return false
	
func remove_effect(type):
	effects.erase(type)
	effect_changed.emit(effects)

func add_effect(type):
	effects.append(type)
	effect_changed.emit(effects)
	
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func start_slashing():
	if slashing:
		return
	slashing = true
	%SlashAnim.play("slash")
	await %SlashAnim.animation_finished
	slashing = false

func is_slashing():
	return slashing

func _process(delta: float) -> void:
	time_playing += delta

func hide_shield():
	%ShieldSprite.visible = false

func show_shield():
	%ShieldSprite.visible = true

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("jump"):
			jumping = true
		if event.is_action_pressed("action"):
			get_parent().level_up()	

func _physics_process(delta):
	if Input.is_action_just_pressed("slash"):
		start_slashing()
	
	if is_on_floor():
		if jump_boost <= 0:
			jump_boost = jump_boost_max
		%PlayerSprite.play("running")
	elif gravity_enabled:
		velocity.y += gravity * delta
		
	if jumping and (is_on_floor() or jump_boost >= 1):
		print("Jumping!")
		velocity.y = JUMP_VELOCITY
		%PlayerSprite.play("jump")
		jump_boost -= 1
		
	jumping = false
	move_and_slide()

func jump():
	jumping = true

func add_health(num: int):
	health += num
	if health > max_health:
		health = max_health
	elif health < 1:
		health = 0

func dead():
	if is_dead:
		return
	is_dead = true
	await get_tree().create_timer(0.5).timeout
	get_parent().show_death_screen(score, level, QuizManager.get_topic())
	SavegameManager.add_save(QuizManager.get_topic(), score, level, timer.time, correct_answer, incorrect_answer)
	SavegameManager.save()
	get_tree().paused = true
