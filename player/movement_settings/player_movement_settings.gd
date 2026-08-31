@tool
class_name PlayerMovementSettings
extends Resource

@export_category("Walk Settings")
@export_range(32, 512) var walk_speed: float:
	set(value):
		walk_speed = value
		if walk_stop_time != 0:
			ground_friction = walk_speed / walk_stop_time
		else:
			ground_friction = max_acceleration
		if walk_start_time != 0:
			ground_acceleration = walk_speed / walk_start_time
		else:
			ground_acceleration = max_acceleration
		
		if air_walk_stop_time != 0:
			air_friction = walk_speed / air_walk_stop_time
		else:
			air_friction = max_acceleration
		if air_walk_start_time != 0:
			air_acceleration = walk_speed / air_walk_start_time
		else:
			air_acceleration = max_acceleration
@export_range(0.01, 1) var walk_start_time: float:
	set(value):
		walk_start_time = value
		if walk_start_time != 0:
			ground_acceleration = walk_speed / walk_start_time
		else:
			ground_acceleration = max_acceleration
@export_range(0.01, 1) var walk_stop_time: float:
	set(value):
		walk_stop_time = value
		if walk_stop_time != 0:
			ground_friction = walk_speed / walk_stop_time
		else:
			ground_friction = max_acceleration
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
		if air_walk_start_time != 0:
			air_acceleration = walk_speed / air_walk_start_time
		else:
			air_acceleration = max_acceleration
@export_range(0.01, 9.0) var air_walk_stop_time: float:
	set(value):
		air_walk_stop_time = value
		if air_walk_stop_time != 0:
			air_friction = walk_speed / air_walk_stop_time
		else:
			air_friction = max_acceleration
@export_category("Dash Settings")
@export_range(10, 512) var dash_distance: float:
	set(value):
		dash_distance = value
		if dash_time != 0:
			dash_speed = dash_distance / dash_time
@export_range(0.3, 2.0) var dash_time: float:
	set(value):
		dash_time = value
		if dash_time != 0:
			dash_speed = dash_distance / dash_time
@export_category("Juice")
@export_range(0, 1.0) var jump_buffer_time: float
@export_range(0, 2.0) var coyote_time: float
@export_category("Limits")
@export_range(0, 1000) var minimum_movement_threshold: float
@export var max_acceleration: float = 999999
@export_range(32.0, 1200.0) var ceiling_clip_min_velocity: float
@export_category("Hidden Settings")
@export var ground_friction: float
@export var ground_acceleration: float
@export var air_friction: float
@export var air_acceleration: float
@export var jump_initial_velocity: float
@export var normal_gravity_acceleration: float
@export var peak_gravity_acceleration: float
@export var fall_gravity_acceleration: float
@export var dash_speed: float
