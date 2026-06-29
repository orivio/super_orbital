extends Node

var player: Player
var camera: PlayerCamera
var current_room: Room
var time_scale: float = 1
var impact_timer: float = 0

func impact():
	if impact_timer <= 0 and time_scale == 1:
		time_scale = 0.0001
		impact_timer = 0.1

func _physics_process(delta: float) -> void:
	if time_scale != 1:
		impact_timer -= delta
		if impact_timer < 0:
			camera.camera_shake.emit()
			time_scale = 1
