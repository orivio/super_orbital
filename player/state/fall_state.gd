class_name FallState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	
	actor.velocity.y += actor.movement_settings.fall_gravity_acceleration * delta
	
	if actor.input.horizontal_input_direction == 0:
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			actor.velocity.x = 0
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.air_friction)
	else:
		var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
		actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.air_acceleration)
	
	actor.move_and_slide()
	
	if actor.is_on_floor():
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			return idle
		else:
			return walk
	
	
	return null
