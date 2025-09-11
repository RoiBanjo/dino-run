class_name GameoverMessage
extends Control

var main_menu: PackedScene
var level: PackedScene

@onready var button_main_menu: Button = %BtnMainMenu
@onready var button_restart: Button = %BtnRestart
@onready var final_score_label: Label = %LblFinalScore


func _ready() -> void:
	main_menu = load("uid://bntrpn65rgcrn")
	level = load("uid://c8b3b2j48wy2v")
	button_restart.grab_focus()
	button_restart.pressed.connect(on_restart.bind())
	button_main_menu.pressed.connect(on_main_menu.bind())
	final_score_label.text = "FINAL SCORE: %s" % GameManager.current_score


func on_restart() -> void:
	GameManager.restart_level()
	

func on_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)