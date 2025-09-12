class_name UI
extends CanvasLayer

const MAX_SCORE_DIGITS := 7

var label_counter := 0

@onready var hearts_container: HBoxContainer = %HeartContainers
@onready var high_score_lbl: Label = %LblHighScore
@onready var ready_timer: Timer = %ReadyTimer
@onready var score_lbl: Label = %LblScore
@onready var start_lbl: Label = $%LblStart


func _ready() -> void:
	GameManager.reduce_health.connect(on_reduce_health.bind())
	ready_timer.timeout.connect(on_ready_timer_timeout.bind())
	update_scores()
	advance_ready_label()
	

func _process(_delta: float) -> void:
	update_scores()


func start_ready_timer() -> void:
	ready_timer.start()
	

func update_scores() -> void:
	score_lbl.text = "SCORE: %s" % add_trailing_zeros(GameManager.current_score)
	high_score_lbl.text = "HIGH SCORE: %s" % add_trailing_zeros(GameManager.high_score)


func advance_ready_label() -> void:
	if label_counter == 0:
		start_lbl.text = "READY ?"
		start_lbl.visible = true
		label_counter += 1
	elif label_counter == 1:
		start_lbl.text = "GO !"
		label_counter += 1
	elif label_counter == 2:
		start_lbl.visible = false
		start_lbl.text = "READY ?"
		label_counter = 0
		ready_timer.stop()


func add_trailing_zeros(number: int) -> String:
	var zeros_to_add: int = MAX_SCORE_DIGITS - (1 if number == 0 else int(floor(log(abs(number)) / log(10))) + 1)
	var result_str: String = ""
	for i in zeros_to_add:
		result_str += "0"
	result_str += str(number)
	return result_str
	
	
func on_ready_timer_timeout() -> void:
	advance_ready_label()


func on_reduce_health() -> void:
	if GameManager.current_health >= 0:
		hearts_container.get_child(GameManager.current_health).deplete()
