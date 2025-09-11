extends Node

signal reduce_health

const LEVEL_PREFAB := preload("uid://c8b3b2j48wy2v")
const MAX_HEALTH := 3

var _current_score: int
var current_health: int
var high_score: int
var selected_dino: int = 0

var current_score: int:
	get:
		return _current_score
	set(value):
		_current_score = value
		check_if_high_score()


func process_hit() -> void:
	current_health -= 1
	reduce_health.emit()


func restart_level():
	get_tree().change_scene_to_packed(LEVEL_PREFAB)


func check_if_high_score() -> void:
	if _current_score >= high_score:
		high_score = _current_score


func reset_starting_values() -> void:
	current_health = MAX_HEALTH
	_current_score = 0
