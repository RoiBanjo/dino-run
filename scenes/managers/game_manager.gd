extends Node

signal reduce_health

const MAX_HEALTH := 3

var current_health: int


func process_hit() -> void:
	current_health -= 1
	reduce_health.emit()