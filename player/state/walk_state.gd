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


func physics_process(_delta: float) -> State:
	if actor.input.horizontal_input_direction == 0:
		return idle
	
	actor.velocity.x = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
	
	actor.move_and_slide()
	return null
