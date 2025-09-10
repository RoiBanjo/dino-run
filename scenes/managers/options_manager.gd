extends Node


const OPTIONS_MENU_PREFAB = preload("uid://b28h31237odhy")

var is_screenshake_enabled := true
var music_volume := 5
var sfx_volume := 10


func _enter_tree() -> void:
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)

	
func set_music_volume(volume: int) -> void:
	music_volume = volume
	AudioServer.set_bus_volume_db(2, linear_to_db(music_volume / 10.0))


func set_sfx_volume(volume: int) -> void:
	sfx_volume = volume
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume / 10.0))


func set_screenshake(value: bool) -> void:
	is_screenshake_enabled = value
