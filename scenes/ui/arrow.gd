class_name Arrow
extends Node2D


const TEXTURE_LEFT := preload("uid://28vmuotor0el")
const TEXTURE_RIGHT := preload("uid://c746ubq3wom75")

@export_enum("LEFT", "RIGHT") var selected_texture

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var texture_array: Array = [TEXTURE_LEFT, TEXTURE_RIGHT]


func _ready() -> void:
	sprite.texture = texture_array[selected_texture]


func play_select() -> void:
	animation_player.play("selection")
	SoundManager.play_sound("sfx_uinav")


func _reset_animation() -> void:
	animation_player.play("idle")
