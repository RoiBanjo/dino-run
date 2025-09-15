class_name Fruit
extends Area2D


const TEXTURES_ARRAY: Array[int] = [0, 2, 5, 6, 9, 15, 17, 19, 22, 25, 30, 31, 37, 39]

var frame := 0

@onready var sprite_hl: Sprite2D = $SpriteHL
@onready var sprite_no_hl: Sprite2D = $SpriteNOHL


func _ready() -> void:
	frame = get_random_fruit_frame()
	sprite_hl.frame = frame
	sprite_no_hl.frame = frame


func get_random_fruit_frame() -> int:
	return TEXTURES_ARRAY[randi_range(0, TEXTURES_ARRAY.size() - 1)]
