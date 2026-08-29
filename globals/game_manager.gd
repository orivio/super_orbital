extends Node

signal player_left_blackhole
signal progress_attained(name: StringName)

var player: Player
var camera: PlayerCamera
var current_level: Level
var time_scale: float = 1
var impacting: bool = false
var impact_timer: float = 0
var play: Play

var levels: Dictionary[String, String] = {
	"move": "uid://dteyafc74ycrl",
	"spike": "uid://buky8cbnivxtx",
	"ladder": "uid://b7mth0jcnis7i",
	"jumpcut": "uid://c1sb0h6scncah",
	"bridge": "uid://ddxmy7jvftye4",
	"gap": "uid://463vcvm62equ",
	"timing": "uid://dtk1cwd2x7bqj",
	"momentum": "uid://dq5o3hg42kqv",
	"platform_spike": "uid://dtohxckxanqyl",
	"long_gap": "uid://bf52ikweswlrf",
	"spike_gap": "uid://cjsjgx5ksbvsd",
	"dash_platform": "uid://xxigq2kqilns",
	"vertical_dash": "uid://drqwhjbyw0tr",
	"no_gravity": "uid://bgq8pnv2gusy2",
	"no_gravity_dash_chain": "uid://dmth7qhi6p4du",
	"change_direction": "uid://d1gjph7nxyegd",
	"wrench": "uid://drwajwykhe8mb",
	"wrench_large": "uid://dftchxtsfo3cy",
	"cant_stop": "uid://q37ng5uis2j3",
	"perchrit": "uid://uvtsgsh0y461",
	"climbing": "uid://dm8o4fu2ncd4e",
	"black_hole": "uid://b7y15sh84lthd",
	"black_hole_angle": "uid://c8jrl1ckwxdxt",
	"wait": "uid://bq4avu843532o",
	"gilganas": "uid://b3tyqkjoa3prk"
}

func _ready() -> void:
	progress_attained.connect(SaveManager._on_progress_attained)
	get_window().min_size = Vector2i(900, 500)

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

func player_leave_blackhole() -> void:
	player_left_blackhole.emit()

func get_level(level: String) -> PackedScene:
	if level_exists(level):
		return load(levels[level])
	return null

func level_exists(level: String) -> bool:
	return levels.has(level)

func attain_progress(progress_name: StringName) -> void:
	progress_attained.emit(progress_name)
