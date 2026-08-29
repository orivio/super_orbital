class_name IdleState
extends State

@onready var walk: State = $"../Walk"
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
	if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
		actor.velocity.x = 0
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.ground_friction)
	
	actor.velocity.y = 100
		
	if actor.can_jump():
		actor.do_jump()
	
	actor.move_and_slide()
	
	if not actor.is_on_floor() and actor.velocity.y < 0:
		return jump
	
	if actor.input.horizontal_input_direction != 0:
		return walk
	
	return null
