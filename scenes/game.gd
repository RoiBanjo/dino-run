extends Node


const DINO_START_POS := Vector2i(100, 554)
const CAMERA_START_POS := Vector2i(576, 324)
const GO_SIGNAL := preload("uid://cmb41isywt1hk")
const GO_SIGNAL_START_POS := Vector2i(300, 564)
const SPEED := 10.0

@export_category("Obstacles")
@export var barrel_scene: PackedScene
@export var box_scene: PackedScene
@export var stump_scene: PackedScene

var is_started: bool = false
var screen_size: Vector2i

@onready var camera: Camera2D = $Camera2D
@onready var dino: Dino = $Dino
@onready var spawns: Node2D = %Spawns
@onready var ground: StaticBody2D = %Ground
@onready var start_timer: Timer = %StartTimer
@onready var spawn_timer: Timer = %SpawnTimer


func _ready() -> void:
	is_started = false
	screen_size = get_window().size
	create_go_signal()
	

func _physics_process(_delta: float) -> void:
	if is_started:
		dino.position.x += SPEED
		camera.position.x += SPEED
		for spawn in spawns.get_children():
			spawn.position.x += SPEED
	if camera.position.x - ground.position.x > screen_size.x * 1.5:
		ground.position.x += screen_size.x


func create_go_signal() -> void:
	var go_signal := GO_SIGNAL.instantiate()
	go_signal.global_position = GO_SIGNAL_START_POS
	add_child(go_signal)


func restart_game() -> void:
	dino.position = DINO_START_POS
	create_go_signal()


func spawn_obstacle(scene: PackedScene) -> void:
	var obstacle = scene.instantiate()
	obstacle.position = spawns.get_child(2).position
	add_child(obstacle)
	obstacle.body_entered.connect(dino.on_obstacle_hit.bind())


func start_game() -> void:
	is_started = true
	spawn_timer.start()
	dino.current_state = dino.State.RUN


func _on_spawn_timer_timeout() -> void:
	spawn_obstacle(stump_scene)


func _on_despawner_area_entered(area: Area2D) -> void:
	area.queue_free()
	

func _on_despawner_body_entered(body: Node2D) -> void:
	body.queue_free()
