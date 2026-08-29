class_name WalkState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var jump: JumpState = $"../Jump"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	
	var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
	actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.ground_acceleration)
	
	if actor.can_jump():
		actor.do_jump()
	
	actor.move_and_slide()
	
	if not actor.is_on_floor() and actor.velocity.y < 0:
		return jump
	
	if actor.input.horizontal_input_direction == 0:
		return idle
	
	return null
