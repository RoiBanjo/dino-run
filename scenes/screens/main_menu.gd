class_name MainMenu
extends Node


const UNSELECTED_COLOR := Color(0.761, 0.502, 0.0)
const SELECTED_COLOR := Color.RED

@export var game_scene: PackedScene

var current_index: int = 0

@onready var menu_nodes: Array[Label] = [%LblStart, %LblOptions, %LblExit]
@onready var selection_icon: Sprite2D = %SelectionIcon


func _ready() -> void:
	SoundManager.play_music(SoundManager.Music.MENU)
	refresh_ui()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		SoundManager.play_sound("sfx_uinav")
		change_index(current_index - 1)
	elif Input.is_action_just_pressed("ui_down"):
		SoundManager.play_sound("sfx_uinav")
		change_index(current_index + 1)
	elif Input.is_action_just_pressed("ui_accept"):
		submit_selection()
	refresh_ui()


func refresh_ui() -> void:
	for i in range(menu_nodes.size()):
		if current_index == i:
			selection_icon.position.y = menu_nodes[i].position.y
			selection_icon.position.x = 420.0
			menu_nodes[i].set("theme_override_colors/font_color", SELECTED_COLOR)
		else:
			menu_nodes[i].set("theme_override_colors/font_color", UNSELECTED_COLOR)


func change_index(new_index: int) -> void:
	current_index = clamp(new_index, 0, menu_nodes.size() - 1)


func submit_selection() -> void:
	SoundManager.play_sound("sfx_uiselect")
	match current_index:
		0:
			get_tree().change_scene_to_packed(game_scene)
		1:
			print("SUBMIT")
		2:
			get_tree().quit()
