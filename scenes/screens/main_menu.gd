class_name MainMenu
extends Node


@export var game_scene: PackedScene

var current_index: int = 0

@onready var menu_nodes: Array[Label] = [%LblStart, %LblOptions, %LblExit]
@onready var selection_icon: Sprite2D = %SelectionIcon


func _ready() -> void:
	refresh_ui()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		change_index(current_index - 1)
	elif Input.is_action_just_pressed("ui_down"):
		change_index(current_index + 1)
	elif Input.is_action_just_pressed("ui_accept"):
		submit_selection()
	refresh_ui()


func refresh_ui() -> void:
	for i in range(menu_nodes.size()):
		if current_index == i:
			selection_icon.position.y = menu_nodes[i].position.y
			selection_icon.position.x = 420.0


func change_index(new_index: int) -> void:
	current_index = clamp(new_index, 0, menu_nodes.size() - 1)


func submit_selection() -> void:
	match current_index:
		0:
			get_tree().change_scene_to_packed(game_scene)
		1:
			print("SUBMIT")
		2:
			get_tree().quit()