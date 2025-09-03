extends Node


const SPEED = 10.0

var is_started: bool = false
var screen_size: Vector2i

@onready var camera: Camera2D = $Camera2D
@onready var dino: Dino = $Dino
@onready var despawner: Area2D = %DespawnerArea
@onready var ground: StaticBody2D = %Ground
@onready var start_timer: Timer = %StartTimer


func _ready() -> void:
	start_timer.timeout.connect(start_game.bind())
	is_started = false
	screen_size = get_window().size
	

func _physics_process(_delta: float) -> void:
	if is_started:
		dino.position.x += SPEED
		camera.position.x += SPEED
		despawner.update_position(SPEED)

	update_ground_position()


func update_ground_position() -> void:
	if camera.position.x - ground.position.x > screen_size.x * 1.5:
		ground.position.x += screen_size.x


func start_game() -> void:
	is_started = true
	dino.start_running()
