class_name Dino
extends CharacterBody2D


enum State {IDLE, DUCK, HIT, JUMP, RUN}

const JUMP_VELOCITY = -900.0

var current_state: State = State.IDLE
var animation_map = {
	State.IDLE: "idle",
	State.DUCK: "duck",
	State.HIT: "hit",
	State.JUMP: "jump",
	State.RUN: "run",
}
var is_enabled: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	is_enabled = false
	current_state = State.IDLE
	var timer_node = get_node("../StartTimer")
	timer_node.timeout.connect(enable_dino.bind())


func _physics_process(delta: float) -> void:
	if is_enabled:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	play_animation()

	move_and_slide()


func play_animation() -> void:
	animation_player.play(animation_map[current_state])


func start_running() -> void:
	current_state = State.RUN


func enable_dino() -> void:
	is_enabled = true
