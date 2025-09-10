class_name Bird
extends Area2D


const FLOAT_AMPLITUDE := 70.0 # Range of movement in pixels
const FLOAT_FREQUENCY := 6.0 # Speed of oscillation

var initial_y := 0.0
var stop_movement := false
var time := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	initial_y = position.y
	animation_player.play("fly")

func _physics_process(delta: float) -> void:
	if not stop_movement:
		time += delta
		position.y = initial_y + sin(time * FLOAT_FREQUENCY) * FLOAT_AMPLITUDE
	else:
		animation_player.play("idle")
