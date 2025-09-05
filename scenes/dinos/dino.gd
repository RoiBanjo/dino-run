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
@onready var collision_run: CollisionShape2D = $CollisionShapeRun
@onready var collision_duck: CollisionShape2D = $CollisionShapeDuck


func _ready() -> void:
	collision_duck.disabled = true
	is_enabled = false
	change_state(State.IDLE)
	var timer_node = get_parent().find_child("StartTimer")
	if timer_node != null:
		timer_node.timeout.connect(enable_dino.bind())


func _physics_process(delta: float) -> void:
	if is_enabled:
		match current_state:
			State.JUMP:
				if not is_on_floor():
					velocity += get_gravity() * 1.5 * delta
				else:
					change_state(State.RUN)
			State.RUN:
				if Input.is_action_just_pressed("ui_accept") and is_on_floor():
					velocity.y = JUMP_VELOCITY
					change_state(State.JUMP)
				elif Input.is_action_pressed("ui_down") and is_on_floor():
					change_state(State.DUCK)
			State.DUCK:
				if Input.is_action_just_released("ui_down"):
					change_state(State.RUN)
			State.HIT:
				if not is_on_floor():
					velocity += get_gravity() * 1.5 * delta


	check_collision_shape()
	play_animation()
	move_and_slide()


func check_collision_shape() -> void:
	if current_state == State.DUCK:
		collision_duck.disabled = false
		collision_run.disabled = true
	else:
		collision_duck.disabled = true
		collision_run.disabled = false


func play_animation() -> void:
	animation_player.play(animation_map[current_state])


func enable_dino() -> void:
	is_enabled = true


func change_state(new_state: State) -> void:
	current_state = new_state


func on_obstacle_hit(_body: Node2D) -> void:
	change_state(State.HIT)


func on_hit_animation_end() -> void:
	if not is_on_floor():
		change_state(State.JUMP)
	else:
		change_state(State.RUN)