extends Node

var player: Player
var camera: PlayerCamera
var current_room: Room
var time_scale: float = 1
var impacting: bool = false
var impact_timer: float = 0
var blackhole: BlackHole #NEED TO MAKE IT SO THAT THE VALUE OF TIME_SCALE DOES NOT RESET WHILE IN BVLACK HOLE ORBIT

func impact():
	if impact_timer <= 0 and time_scale == 1:
		time_scale = 0.0001
		impact_timer = 0.2
		impacting = true


func _physics_process(delta: float) -> void:
	if impacting and time_scale != 1:
		impact_timer -= delta
		if impact_timer < 0:
			camera.camera_shake.emit()
			time_scale = 1
			impacting = false

func lock_input() -> void:
	player.input_locked = true
	
func unlock_input() -> void:
	player.input_locked = false
