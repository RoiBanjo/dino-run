class_name UI
extends CanvasLayer

const MAX_SCORE_DIGITS := 6

@onready var hearts_container: HBoxContainer = %HeartContainers
@onready var high_score_lbl: Label = %LblHighScore
@onready var score_lbl: Label = %LblScore


func _ready() -> void:
	GameManager.reduce_health.connect(on_reduce_health.bind())
	high_score_lbl.text = "HIGH SCORE: %s" % add_trailing_zeros(GameManager.high_score)
	score_lbl.text = "SCORE: %s" % add_trailing_zeros(GameManager.current_score)
	

func on_reduce_health() -> void:
	if GameManager.current_health >= 0:
		hearts_container.get_child(GameManager.current_health).deplete()


func add_trailing_zeros(number: int) -> String:
	var zeros_to_add: int = MAX_SCORE_DIGITS - (1 if number == 0 else int(floor(log(abs(number)) / log(10))) + 1)
	var result_str: String = ""
	for i in zeros_to_add:
		result_str += "0"
	result_str += str(number)
	return result_str