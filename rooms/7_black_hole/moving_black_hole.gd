extends AnimatableBody2D


@export var orbit_pos: Vector2
@export var orbit_radius: float
@export var orbit_speed: float
@export var time_offset: float


var time: float


func _ready() -> void:
	time = time_offset


func _physics_process(delta: float) -> void:
	time += delta * GameManager.time_scale
	global_position = orbit_pos + Vector2(cos(time * orbit_speed * PI * 2) * orbit_radius, sin(time * orbit_speed * PI * 2) * orbit_radius)
