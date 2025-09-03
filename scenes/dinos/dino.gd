class_name Dino
extends CharacterBody2D


enum State {IDLE, DUCK, HIT, JUMP, RUN}

const JUMP_VELOCITY = -800.0

var current_state: State = State.IDLE
var animation_map = {
	State.IDLE: "idle",
	State.DUCK: "duck",
	State.HIT: "hit",
	State.JUMP: "jump",
	State.RUN: "run",
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	current_state = State.IDLE


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	play_animation()

	move_and_slide()


func play_animation() -> void:
	animation_player.play(animation_map[current_state])


func start_running() -> void:
	current_state = State.RUN