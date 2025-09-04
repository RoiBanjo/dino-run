extends Node


const DINO_START_POS := Vector2i(100, 554)
const CAMERA_START_POS := Vector2i(576, 324)
const GO_SIGNAL_START_POS := Vector2i(300, 564)
const SPEED := 10.0
const GO_SIGNAL := preload("uid://cmb41isywt1hk")


var is_started: bool = false
var screen_size: Vector2i

@onready var camera: Camera2D = $Camera2D
@onready var dino: Dino = $Dino
@onready var spawns: Node2D = %Spawns
@onready var ground: StaticBody2D = %Ground
@onready var start_timer: Timer = %StartTimer


func _ready() -> void:
	start_timer.timeout.connect(start_game.bind())
	is_started = false
	screen_size = get_window().size
	create_go_signal()
	

func _physics_process(_delta: float) -> void:
	if is_started:
		dino.position.x += SPEED
		camera.position.x += SPEED
		for spawn in spawns.get_children():
			spawn.position.x += SPEED

	update_ground_position()


func update_ground_position() -> void:
	if camera.position.x - ground.position.x > screen_size.x * 1.5:
		ground.position.x += screen_size.x


func start_game() -> void:
	is_started = true


func _on_despawner_body_entered(body: Node2D) -> void:
	body.queue_free()


func create_go_signal() -> void:
	var go_signal := GO_SIGNAL.instantiate()
	go_signal.global_position = GO_SIGNAL_START_POS
	add_child(go_signal)


func restart_game() -> void:
	dino.position = DINO_START_POS

	create_go_signal()
