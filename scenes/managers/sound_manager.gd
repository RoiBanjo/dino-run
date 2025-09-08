extends Node


@onready var sfx_jump: AudioStreamPlayer = $SFXjump
@onready var sfx_run: AudioStreamPlayer = $SFXrun
@onready var sfx_hit: AudioStreamPlayer = $SFXhit
@onready var sfx_bonk: AudioStreamPlayer = $SFXbonk


func play_sound(key: StringName, tweak_pitch: bool = false):
	var added_pitch := 0.0
	var sound = get(key)
	if tweak_pitch:
		added_pitch = randf_range(-0.005, 0.005)
	if sound is AudioStreamPlayer:
		sound.pitch_scale = 1.0 + added_pitch
		sound.play()
	else:
		print("Sound " + key + " not found!")
