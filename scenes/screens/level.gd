extends Node


const DINO_START_POS := Vector2i(100, 554)
const CAMERA_START_POS := Vector2i(576, 324)
const GO_SIGN := preload("uid://cmb41isywt1hk")
const GO_SIGN_START_POS := Vector2i(300, 564)
const GAME_SPEED: Dictionary = {
	"Easy": 10.0,
	"Normal": 10.0,
	"Hard": 15.0,
	"Impossible": 20.0,
}
const SPAWN_DELAY: Dictionary = {
	"Easy": 3.0,
	"Normal": 2.5,
	"Hard": 2.0,
	"Impossible": 1.5,
}

@export_enum("Easy", "Normal", "Hard", "Impossible") var game_difficulty: String
@export var obstacles: Array[PackedScene]
@export var bird: PackedScene
@export var mushroom: PackedScene

var current_enemy: Area2D = null
var current_obstacle: Area2D = null
var gameover: bool = false
var is_started: bool = false
var previous_enemy: Area2D = null
var screen_size: Vector2i
var speed := 0.0

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
	obstacles.shuffle()
	speed = GAME_SPEED[game_difficulty]
	SoundManager.play_music(SoundManager.Music.LEVEL)
	

func _physics_process(_delta: float) -> void:
	if is_started and not gameover:
		dino.position.x += speed
		camera.position.x += speed
		for spawn in spawns.get_children():
			spawn.position.x += speed
	if camera.position.x - ground.position.x > screen_size.x * 1.5:
		ground.position.x += screen_size.x


func create_go_sign() -> void:
	var go_sign := GO_SIGN.instantiate()
	go_sign.global_position = GO_SIGN_START_POS
	add_child(go_sign)


func restart_game() -> void:
	is_started = false
	dino.reset()
	create_go_sign()
	if current_enemy != null:
		current_enemy = null
	if previous_enemy != null:
		previous_enemy = null
	if current_obstacle != null:
		current_obstacle = null
	start_timer.start()
	

func spawn_obstacle(scene: PackedScene) -> void:
	var obstacle = scene.instantiate()
	obstacle.position = spawns.get_child(2).position
	add_child(obstacle)
	obstacle.body_entered.connect(on_dino_hit.bind())
	current_obstacle = obstacle


func spawn_enemy(scene: PackedScene) -> void:
	if current_enemy != null:
		previous_enemy = current_enemy
	var enemy = scene.instantiate()
	if enemy.name == "Mushroom":
		enemy.position = spawns.get_child(2).position
		if enemy.has_node("Hurtbox"):
			enemy.get_node("Hurtbox").body_entered.connect(dino.rebound.bind())
	else:
		enemy.position = spawns.get_child(1).position
	add_child(enemy)
	enemy.body_entered.connect(on_dino_hit.bind())
	current_enemy = enemy


func start_game() -> void:
	is_started = true
	start_timer.stop()
	spawn_timer.start(SPAWN_DELAY[game_difficulty])
	dino.enable_dino()


func end_game() -> void:
	SoundManager.stop_music()
	SoundManager.play_sound("sfx_lose")
	spawn_timer.stop()
	gameover = true
	if current_obstacle != null:
		current_obstacle.set_deferred("monitoring", false)
	if current_enemy != null:
		current_enemy.set_deferred("monitoring", false)
		current_enemy.stop_movement = true
	if previous_enemy != null:
		previous_enemy.set_deferred("monitoring", false)
		previous_enemy.stop_movement = true
	dino.die()
	
	
func _on_spawn_timer_timeout() -> void:
	if not gameover:
		var create_enemy := randi_range(0, 10) <= 4
		if create_enemy:
			if randi_range(0, 2) == 0:
				spawn_enemy(mushroom)
			else:
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


func on_dino_hit(_body: Node2D) -> void:
	dino.hit()
	camera.shake()
	if GameManager.current_health == 0:
		end_game()