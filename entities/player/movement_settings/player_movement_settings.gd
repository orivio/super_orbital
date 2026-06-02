class_name PlayerMovementSettings extends Resource

@export var move_speed: float
@export var jump_velocity: float
@export var gravity: float
@export var downward_gravity_multiplier: float
@export var air_speed_multiplier: float
@export var dash_velocity: float
@export var dash_time: float
@export var dash_distance: float:
	set(value):
		dash_time = value / dash_velocity
