extends Node

signal player_left_blackhole
signal progress_attained(name: StringName)

var player: Player
var camera: PlayerCamera
var current_level: Level
var time_scale: float = 1
var play: Play

func _ready() -> void:
	progress_attained.connect(SaveManager._on_progress_attained)
	get_window().min_size = Vector2i(900, 500)


func hitstop(time: float) -> void:
	if Engine.time_scale == 0.0 or time == 0.0:
		return
	Engine.time_scale = 0.0
	get_tree().create_timer(time, true, true, true).timeout.connect(_on_hitstop_end)


func camera_shake_directional(direction: Vector2, strength: float) -> void:
	camera.shake_in_direction(direction, strength)


func camera_shake(strength: float) -> void:
	camera.camera_shake.emit()

func player_leave_blackhole() -> void:
	player_left_blackhole.emit()


func attain_progress(progress_name: StringName) -> void:
	progress_attained.emit(progress_name)


func _on_hitstop_end() -> void:
	Engine.time_scale = 1.0
