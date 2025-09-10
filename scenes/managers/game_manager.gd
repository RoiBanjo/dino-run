extends Node

signal reduce_health

const MAX_HEALTH := 3

var current_health: int
var current_score: int
var high_score: int
var selected_dino: int = 0

func process_hit() -> void:
	current_health -= 1
	reduce_health.emit()