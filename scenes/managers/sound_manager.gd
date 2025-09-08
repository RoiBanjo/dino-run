extends Node

enum Music {MENU, LEVEL}

const MUSIC_MAP: Dictionary = {
	Music.MENU: preload("uid://wktrydp8vqs3"),
	Music.LEVEL: preload("uid://bnkogmtky3wil"),
}

@onready var music_stream_player: AudioStreamPlayer = $MusicStreamPlayer
@onready var sfx_jump: AudioStreamPlayer = $SFXjump
@onready var sfx_run: AudioStreamPlayer = $SFXrun
@onready var sfx_hit: AudioStreamPlayer = $SFXhit
@onready var sfx_bonk: AudioStreamPlayer = $SFXbonk
@onready var sfx_lose: AudioStreamPlayer = $SFXlose

var autoplay_music: AudioStream = null


func _ready() -> void:
	if autoplay_music != null:
		music_stream_player.stream = autoplay_music
		music_stream_player.play()


func play_sound(key: StringName, tweak_pitch: bool = false) -> void:
	var added_pitch := 0.0
	var sound = get(key)
	if tweak_pitch:
		added_pitch = randf_range(-0.005, 0.005)
	if sound is AudioStreamPlayer:
		sound.pitch_scale = 1.0 + added_pitch
		sound.play()
	else:
		print("Sound " + key + " not found!")


func play_music(music: Music) -> void:
	if music_stream_player.is_node_ready():
		music_stream_player.stream = MUSIC_MAP[music]
		music_stream_player.play()
	else:
		autoplay_music = MUSIC_MAP[music]


func stop_music() -> void:
	music_stream_player.stop()
