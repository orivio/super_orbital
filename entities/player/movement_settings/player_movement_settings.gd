@tool

class_name PlayerMovementSettings extends Resource

@export_range(300, 1000) var move_speed: float
@export_range(600, 2000) var jump_velocity: float
@export_range(20, 80) var gravity: float
@export_range(1, 3) var downward_gravity_multiplier: float
@export_range(0.1, 1) var air_speed_multiplier: float
@export_range(0, 10000) var dash_velocity: float
@export_range(0, 1) var dash_time: float
@export_range(100, 1000) var dash_distance: float
@export var mass: float
@export var wrench_velocity: float
