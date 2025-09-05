class_name HeartContainer
extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func deplete() -> void:
	animation_player.play("deplete")