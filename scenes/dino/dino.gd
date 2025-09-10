class_name Dino
extends CharacterBody2D


enum State {IDLE, DUCK, HIT, JUMP, RUN, DIE, WAIT_RESTART}

const DIE_VELOCITY = -800
const JUMP_VELOCITY = -900.0
const REBOUND_VELOCITY = -400.0
const RUN_SFX_INTERVAL := 0.3

const TEXTURE_RED := preload("uid://c1kdx4s6g1rs")
const TEXTURE_GREEN := preload("uid://me55bdpts0ps")
const TEXTURE_YELLOW := preload("uid://c2ob8ar2w0rnc")
const TEXTURE_BLUE := preload("uid://brqnabsw7je7h")


var animation_map = {
	State.IDLE: "idle",
	State.DUCK: "duck",
	State.HIT: "hit",
	State.JUMP: "jump",
	State.RUN: "run",
	State.DIE: "die",
	State.WAIT_RESTART: "wait_restart"
}
var current_state: State = State.IDLE
var is_enabled: bool = false
var run_sfx_timer := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_run: CollisionShape2D = $CollisionShapeRun
@onready var collision_duck: CollisionShape2D = $CollisionShapeDuck
@onready var ray_shadow: RayCast2D = %RayShadow
@onready var sprite_dino: Sprite2D = $Sprite2D
@onready var sprite_shadow: Sprite2D = %ShadowSprite
@onready var textures_array: Array = [TEXTURE_RED, TEXTURE_GREEN, TEXTURE_YELLOW, TEXTURE_BLUE]


func _ready() -> void:
	change_texture(GameManager.selected_dino)
	sprite_dino.flip_v = false
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
					handle_gravity(delta)
				else:
					change_state(State.RUN)
			State.RUN:
				if Input.is_action_just_pressed("ui_accept"):
					jump()
				elif Input.is_action_pressed("ui_down"):
					change_state(State.DUCK)
			State.DUCK:
				if Input.is_action_just_released("ui_down"):
					change_state(State.RUN)
				if Input.is_action_just_pressed("ui_accept"):
					jump()
			State.HIT:
				if not is_on_floor():
					handle_gravity(delta)
			State.DIE:
				handle_gravity(delta)
				change_state(State.WAIT_RESTART)
			State.WAIT_RESTART:
				handle_gravity(delta)
				is_enabled = false
	elif velocity != Vector2.ZERO:
		handle_gravity(delta)
	check_collision_shape()
	play_animation()
	play_run_sfx(delta)
	move_and_slide()
	render_shadow()


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	change_state(State.JUMP)
	SoundManager.play_sound("sfx_jump")


func check_collision_shape() -> void:
	if current_state == State.DUCK:
		collision_duck.disabled = false
		collision_run.disabled = true
	else:
		collision_duck.disabled = true
		collision_run.disabled = false


func handle_gravity(delta: float) -> void:
	velocity += get_gravity() * 1.5 * delta


func play_animation() -> void:
	animation_player.play(animation_map[current_state])


func play_run_sfx(delta: float) -> void:
	if (current_state == State.RUN or current_state == State.DUCK) and is_on_floor():
		run_sfx_timer += delta
		if run_sfx_timer >= RUN_SFX_INTERVAL:
			SoundManager.play_sound("sfx_run", true)
			run_sfx_timer = 0.0
	else:
		run_sfx_timer = 0.0


func enable_dino() -> void:
	is_enabled = true
	change_state(State.RUN)


func die() -> void:
	change_state(State.DIE)
	velocity.y = DIE_VELOCITY


func reset() -> void:
	sprite_dino.flip_v = false
	collision_duck.disabled = true
	is_enabled = false
	change_state(State.IDLE)
	

func change_state(new_state: State) -> void:
	current_state = new_state


func rebound(_body: Node2D) -> void:
	velocity.y = REBOUND_VELOCITY


func render_shadow() -> void:
	if ray_shadow.is_colliding():
		sprite_shadow.global_position.y = ray_shadow.get_collision_point().y - 20
		var height_ratio: float = clamp(1.0 - sprite_shadow.position.y / 30.0, 0.1, 0.8)
		sprite_shadow.modulate.a = height_ratio
		var shadow_scale: float = max(height_ratio, 0.6)
		sprite_shadow.scale = Vector2(shadow_scale, shadow_scale)


func disable_shadow() -> void:
	sprite_shadow.visible = false
	ray_shadow.enabled = false


func change_texture(index: int) -> void:
	sprite_dino.texture = textures_array[index]


func hit() -> void:
	if current_state != State.HIT and current_state != State.DIE and current_state != State.WAIT_RESTART:
		change_state(State.HIT)
		SoundManager.play_sound("sfx_hit", true)
		GameManager.process_hit()

	
func on_hit_animation_end() -> void:
	if not is_on_floor():
		change_state(State.JUMP)
	else:
		change_state(State.RUN)
