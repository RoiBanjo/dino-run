class_name UI
extends CanvasLayer


@onready var hearts_container: HBoxContainer = %HeartContainers


func _ready() -> void:
	GameManager.reduce_health.connect(on_reduce_health.bind())
	

func on_reduce_health() -> void:
	if GameManager.current_health >= 0:
		hearts_container.get_child(GameManager.current_health).deplete()
