extends Node


const DINO_START_POS := Vector2i(100, 554)
const CAMERA_START_POS := Vector2i(576, 324)
const GO_SIGN := preload("uid://cmb41isywt1hk")
const GO_SIGN_START_POS := Vector2i(300, 564)
const SPEED := 10.0

@export var obstacles: Array[PackedScene]
@export var bird: PackedScene

var current_enemy: Area2D = null
var current_obstacle: Area2D = null
var gameover: bool = false
var is_started: bool = false
var previous_enemy: Area2D = null
var screen_size: Vector2i

@onready var camera: Camera2D = $Camera2D
@onready var dino: Dino = $Dino
@onready var spawns: Node2D = %Spawns
@onready var ground: StaticBody2D = %Ground
@onready var start_timer: Timer = %StartTimer
@onready var spawn_timer: Timer = %SpawnTimer
@onready var ui: CanvasLayer = $UI


func _ready() -> void:
	GameManager.current_health = GameManager.MAX_HEALTH
	is_started = false
	screen_size = get_window().size
	create_go_sign()
	# obstacles = obstacles.filter(func(scene): return scene != null)
	obstacles.shuffle()
	GameManager.reduce_health.connect(on_reduce_health.bind())
	

func _physics_process(_delta: float) -> void:
	if is_started and not gameover:
		dino.position.x += SPEED
		camera.position.x += SPEED
		for spawn in spawns.get_children():
			spawn.position.x += SPEED
	if camera.position.x - ground.position.x > screen_size.x * 1.5:
		ground.position.x += screen_size.x


func create_go_sign() -> void:
	var go_sign := GO_SIGN.instantiate()
	go_sign.global_position = GO_SIGN_START_POS
	add_child(go_sign)


func restart_game() -> void:
	is_started = false
	dino.position = DINO_START_POS
	create_go_sign()
	start_timer.start()


func spawn_obstacle(scene: PackedScene) -> void:
	var obstacle = scene.instantiate()
	obstacle.position = spawns.get_child(2).position
	add_child(obstacle)
	obstacle.body_entered.connect(dino.on_obstacle_hit.bind())
	current_obstacle = obstacle


func spawn_enemy(scene: PackedScene) -> void:
	if current_enemy != null:
		previous_enemy = current_enemy
	var enemy = scene.instantiate()
	enemy.position = spawns.get_child(1).position
	add_child(enemy)
	enemy.body_entered.connect(dino.on_obstacle_hit.bind())
	current_enemy = enemy


func start_game() -> void:
	is_started = true
	start_timer.stop()
	spawn_timer.start()
	dino.enable_dino()


func end_game() -> void:
	spawn_timer.stop()
	gameover = true
	if current_obstacle != null:
		current_obstacle.set_deferred("monitoring", false)
	if current_enemy != null:
		current_enemy.set_deferred("monitoring", false)
	if previous_enemy != null:
		previous_enemy.set_deferred("monitoring", false)
	dino.die()
	

func _on_spawn_timer_timeout() -> void:
	if not gameover:
		var create_enemy := randi_range(0, 2) == 0
		if create_enemy:
			spawn_enemy(bird)
		else:
			spawn_obstacle(obstacles[randi_range(0, obstacles.size() - 1)])


func _on_despawner_area_entered(area: Area2D) -> void:
	if area == current_enemy:
		current_enemy = null
	elif area == current_obstacle:
		current_obstacle = null
	area.queue_free()
	

func _on_despawner_body_entered(body: Node2D) -> void:
	body.queue_free()


func on_reduce_health() -> void:
	if GameManager.current_health == 0:
		end_game()
