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
			ground_friction = 99999
@export_range(0, 1) var walk_start_time: float
@export_range(0, 1) var walk_stop_time: float:
	set(value):
		walk_stop_time = value
		if walk_stop_time != 0:
			ground_friction = walk_speed / walk_stop_time
		else:
			ground_friction = 99999

@export_category("Snapping Settings")
@export_range(0, 10) var minimum_movement_threshold: float

@export_group("Hidden Settings")
@export var ground_friction: float
