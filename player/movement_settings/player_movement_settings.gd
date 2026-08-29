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
			ground_friction = max_ground_acceleration
		if walk_start_time != 0:
			ground_acceleration = walk_speed / walk_start_time
		else:
			ground_acceleration = max_ground_acceleration
@export_range(0, 1) var walk_start_time: float:
	set(value):
		walk_start_time = value
		if walk_start_time != 0:
			ground_acceleration = walk_speed / walk_start_time
		else:
			ground_acceleration = max_ground_acceleration
@export_range(0, 1) var walk_stop_time: float:
	set(value):
		walk_stop_time = value
		if walk_stop_time != 0:
			ground_friction = walk_speed / walk_stop_time
		else:
			ground_friction = max_ground_acceleration
@export_category("Juice")
@export var jump_buffer_time: float
@export_category("Snapping Settings")
@export_range(0, 1000) var minimum_movement_threshold: float
@export_category("Limits")
@export var max_ground_acceleration: float = 999999
@export_category("Hidden Settings")
@export var ground_friction: float
@export var ground_acceleration: float
@export var jump_initial_velocity: float
@export var normal_gravity_acceleration: float
