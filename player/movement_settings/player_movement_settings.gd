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
@export_range(0, 1) var walk_start_time: float:
	set(value):
		walk_start_time = value
		if walk_start_time != 0:
			ground_acceleration = walk_speed / walk_start_time
		else:
			ground_acceleration = max_acceleration
@export_range(0, 1) var walk_stop_time: float:
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
@export_category("Air Settings")
@export var air_walk_start_time: float:
	set(value):
		air_walk_start_time = value
		if air_walk_start_time != 0:
			air_acceleration = walk_speed / air_walk_start_time
		else:
			air_acceleration = max_acceleration
@export var air_walk_stop_time: float:
	set(value):
		air_walk_stop_time = value
		if air_walk_stop_time != 0:
			air_friction = walk_speed / air_walk_stop_time
		else:
			air_friction = max_acceleration
@export_category("Juice")
@export var jump_buffer_time: float
@export_category("Snapping Settings")
@export_range(0, 1000) var minimum_movement_threshold: float
@export_category("Limits")
@export var max_acceleration: float = 999999
@export_category("Hidden Settings")
@export var ground_friction: float
@export var ground_acceleration: float
@export var air_friction: float
@export var air_acceleration: float
@export var jump_initial_velocity: float
@export var normal_gravity_acceleration: float
