class_name JumpState
extends State

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	
	actor.velocity.y += actor.movement_settings.normal_gravity_acceleration * delta
	
	actor.move_and_slide()
	
	if actor.is_on_floor():
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			return idle
		else:
			return walk
	
	
	return null
