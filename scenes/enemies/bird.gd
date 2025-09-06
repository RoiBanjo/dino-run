class_name Bird
extends Area2D


const FLOAT_AMPLITUDE := 60.0 # Range of movement in pixels
const FLOAT_FREQUENCY := 6.0 # Speed of oscillation

var initial_y := 0.0
var time := 0.0


func _ready() -> void:
	initial_y = position.y


func _physics_process(delta: float) -> void:
	time += delta
	position.y = initial_y + sin(time * FLOAT_FREQUENCY) * FLOAT_AMPLITUDE
