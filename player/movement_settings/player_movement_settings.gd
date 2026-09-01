@tool
class_name PlayerMovementSettings
extends Resource

signal debug_visual_changed

@export_category("Walk Settings")
@export_range(32, 512) var walk_speed: float:
	set(value):
		walk_speed = value
		ground_friction = walk_speed / walk_stop_time
		ground_acceleration = walk_speed / walk_start_time
		air_friction = walk_speed / air_walk_stop_time
		air_acceleration = walk_speed / air_walk_start_time
@export_range(0.01, 1) var walk_start_time: float:
	set(value):
		walk_start_time = value
		ground_acceleration = walk_speed / walk_start_time
@export_range(0.01, 1) var walk_stop_time: float:
	set(value):
		walk_stop_time = value
		ground_friction = walk_speed / walk_stop_time
@export_category("Jump Settings")
@export_range(0, 1000) var jump_max_height: float:
	set(value):
		jump_max_height = value
		jump_initial_velocity = 2 * jump_max_height / jump_peak_time
		normal_gravity_acceleration = 2 * jump_max_height / (jump_peak_time * jump_peak_time)
@export_range(0.1, 9) var jump_peak_time: float:
	set(value):
		jump_peak_time = value
		jump_initial_velocity = 2 * jump_max_height / jump_peak_time
		normal_gravity_acceleration = 2 * jump_max_height / (jump_peak_time * jump_peak_time)
@export_range(0.1, 9) var jump_fall_time: float:
	set(value):
		jump_fall_time = value
		fall_gravity_acceleration = 2 * jump_max_height / (jump_fall_time * jump_fall_time)
@export_category("Air Settings")
@export_range(0.01, 9.0) var air_walk_start_time: float:
	set(value):
		air_walk_start_time = value
		air_acceleration = walk_speed / air_walk_start_time
@export_range(0.01, 9.0) var air_walk_stop_time: float:
	set(value):
		air_walk_stop_time = value
		air_friction = walk_speed / air_walk_stop_time
@export_category("Dash Settings")
@export var allow_orthognal_dash: bool
@export_range(10.0, 512) var dash_distance: float:
	set(value):
		dash_distance = value
		dash_velocity = dash_distance / dash_time
		debug_visual_changed.emit()
@export_range(0.01, 1.0) var dash_time: float:
	set(value):
		dash_time = value
		dash_velocity = dash_distance / dash_time
		debug_visual_changed.emit()
@export_range(10.0, 512.0) var dash_exit_distance: float:
	set(value):
		dash_exit_distance = value
		var dash_exit_velocity: float = dash_exit_distance / dash_exit_time
		dash_exit_diminish = dash_exit_velocity / (dash_distance / dash_time)
		debug_visual_changed.emit()
@export_range(0.01, 1.0) var dash_exit_time: float:
	set(value):
		dash_exit_time = value
		var dash_exit_velocity: float = dash_exit_distance / dash_exit_time
		dash_exit_diminish = dash_exit_velocity / (dash_distance / dash_time)
		debug_visual_changed.emit()
@export_range(0.0, 1.0) var upward_dash_scale: float:
	set(value):
		upward_dash_scale = value
		debug_visual_changed.emit()
@export_range(0.0, 1.0) var orthogonal_dash_scale: float:
	set(value):
		orthogonal_dash_scale = value
		debug_visual_changed.emit()
@export_range(0.0, 2.0) var dash_cooldown: float
@export_category("Juice")
@export_range(0, 1.0) var jump_buffer_time: float
@export_range(0, 2.0) var coyote_time: float
@export_range(0.0, 1.0) var dash_hitstop: float
@export_category("Limits")
@export_range(0, 1000) var minimum_movement_threshold: float
@export var max_acceleration: float = 999999
@export_range(32.0, 1200.0) var ceiling_clip_min_velocity: float
@export_category("Debug Visuals")
@export var show_dash_breakdown: bool:
	set(value):
		if value == true:
			debug_visual_changed.emit()
@export_category("Hidden Settings")
@export var ground_friction: float
@export var ground_acceleration: float
@export var air_friction: float
@export var air_acceleration: float
@export var jump_initial_velocity: float
@export var normal_gravity_acceleration: float
@export var peak_gravity_acceleration: float
@export var fall_gravity_acceleration: float
@export var dash_velocity: float
@export var dash_exit_diminish: float
