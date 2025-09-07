class_name Mushroom
extends Area2D


var stop_movement := false
var hurt := false

@onready var idle_sprite: Sprite2D = $SpriteIdle
@onready var hurt_sprite: Sprite2D = $SpriteStun
@onready var idle_animation_player: AnimationPlayer = $SpriteIdle/AnimationPlayer
@onready var hurt_animation_player: AnimationPlayer = $SpriteStun/AnimationPlayer
@onready var hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	idle_sprite.visible = true
	idle_animation_player.play()
	hurt_sprite.visible = false
	hurt_animation_player.stop()


func _physics_process(_delta: float) -> void:
	if hurt and not stop_movement:
		idle_sprite.visible = false
		idle_animation_player.stop()
		hurt_sprite.visible = true
		if not hurt_animation_player.is_playing():
			hurt_animation_player.play()
	elif hurt and stop_movement:
		hurt_animation_player.stop()
	elif stop_movement:
		idle_sprite.visible = true
		idle_animation_player.stop()
	else:
		hurt_sprite.visible = false
		if not idle_animation_player.is_playing():
			idle_animation_player.play()


func _on_body_entered(_body: Node2D) -> void:
	hurtbox.monitoring = false


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	hurt = true
	monitoring = false
