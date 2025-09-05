class_name UI
extends CanvasLayer


const MAX_HEALTH := 3

@onready var current_health := MAX_HEALTH
@onready var hearts_container: HBoxContainer = %HeartContainers


func on_obstacle_hit(_body: Node2D) -> void:
	if current_health > 1:
		current_health -= 1
		hearts_container.get_child(current_health).deplete()
	elif current_health == 1:
		current_health -= 1
		hearts_container.get_child(current_health).deplete()
		print("GAME OVER")
	else:
		print("GAME OVER")
