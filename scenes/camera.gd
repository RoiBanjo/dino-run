class_name MovingCamera
extends Camera2D


const SHAKE_DURATION := 150
const SHAKE_INTENSITY := 10

var is_shaking := false
var shake_timer: int = 0


func _physics_process(_delta: float) -> void:
	if is_shaking:
		offset = Vector2(0.0, randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
		if Time.get_ticks_msec() - shake_timer > SHAKE_DURATION:
			is_shaking = false
	else:
		offset = Vector2.ZERO


func shake() -> void:
	shake_timer = Time.get_ticks_msec()
	is_shaking = true
