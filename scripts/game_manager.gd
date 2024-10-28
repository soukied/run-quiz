extends Node

signal player_set(player:Player)
var _world : World = null
var _player : Player = null

func clear_world():
	_world = null
	
func set_world(new_world: World):
	_world = new_world
	
func get_world() -> World:
	return _world
	
func get_player() -> Player:
	return _player
	
func clear_player():
	_player = null
	
func set_player(new_player: Player):
	_player = new_player
	if new_player:
		player_set.emit(new_player)
