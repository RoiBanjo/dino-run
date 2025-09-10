extends Node


var level: PackedScene
var main_menu: PackedScene
var selection_index: int = 0

@onready var arrow_left: Arrow = %ArrowL
@onready var arrow_right: Arrow = %ArrowR
@onready var dino: Dino = %Dino


func _ready() -> void:
	main_menu = load("uid://bntrpn65rgcrn")
	level = load("uid://c8b3b2j48wy2v")
	dino.change_texture(GameManager.selected_dino)
	dino.is_enabled = false
	dino.disable_shadow()
	dino.change_state(dino.State.RUN)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		arrow_left.play_select()
		selection_index -= 1
		if selection_index < 0: selection_index = dino.textures_array.size() - 1
	elif Input.is_action_just_pressed("ui_right"):
		arrow_right.play_select()
		selection_index += 1
		if selection_index >= dino.textures_array.size(): selection_index = 0
	elif Input.is_action_just_pressed("ui_accept"):
		SoundManager.play_sound("sfx_uiselect")
		GameManager.selected_dino = selection_index
		get_tree().change_scene_to_packed(level)
	elif Input.is_action_just_pressed("ui_cancel"):
		SoundManager.play_sound("sfx_uiselect")
		get_tree().change_scene_to_packed(main_menu)
	dino.change_texture(selection_index)