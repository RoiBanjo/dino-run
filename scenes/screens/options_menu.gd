class_name OptionsMenu
extends Control

signal option_menu_exit

@onready var btn_diff: Button = %BtnDiff
@onready var btn_return: Button = %BtnReturn
@onready var shake_check: CheckBox = %ChkShake
@onready var slider_sfx: Slider = %SliderSFX
@onready var slider_music: Slider = %SliderMusic


func _ready() -> void:
	shake_check.button_pressed = OptionsManager.is_screenshake_enabled
	slider_sfx.value = OptionsManager.sfx_volume
	slider_music.value = OptionsManager.music_volume
	btn_diff.selected = OptionsManager.game_difficulty
	btn_diff.grab_focus()
	slider_music.value_changed.connect(on_music_value_change.bind())
	slider_sfx.value_changed.connect(on_sfx_value_change.bind())
	shake_check.toggled.connect(on_shake_value_change.bind())
	btn_return.pressed.connect(on_return_button_pressed.bind())
	btn_diff.item_selected.connect(on_diff_selected.bind())


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		exit_menu()


func exit_menu() -> void:
	SoundManager.play_sound("sfx_uiselect")
	option_menu_exit.emit()
	queue_free()


func on_diff_selected(new_value: int) -> void:
	OptionsManager.set_game_difficulty(new_value)


func on_music_value_change(new_value: int) -> void:
	SoundManager.play_sound("sfx_uinav")
	OptionsManager.set_music_volume(new_value)


func on_sfx_value_change(new_value: int) -> void:
	SoundManager.play_sound("sfx_uinav")
	OptionsManager.set_sfx_volume(new_value)


func on_shake_value_change(new_value: bool) -> void:
	SoundManager.play_sound("sfx_uinav")
	OptionsManager.set_screenshake(new_value)


func on_return_button_pressed() -> void:
	exit_menu()
