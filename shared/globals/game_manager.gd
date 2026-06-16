extends Node

var player: Player
var camera: PlayerCamera
var time_scale: float = 1
var timer: float = 0
func impact():
	time_scale = 0.1
	timer = 0.1
func _physics_process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		time_scale = 1
