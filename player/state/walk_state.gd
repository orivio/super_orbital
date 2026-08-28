class_name WalkState
extends State

@onready var idle: IdleState = $"../Idle"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	if actor.input.horizontal_input_direction == 0:
		return idle
	
	var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
	actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.ground_acceleration)
	
	actor.move_and_slide()
	return null
