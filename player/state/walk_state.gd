class_name WalkState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var jump: JumpState = $"../Jump"
@onready var fall: FallState = $"../Fall"


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
	
	var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
	actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.ground_acceleration)
	
	if actor.can_jump() and not actor.input_locked:
		actor.do_jump()
	
	actor.move_and_slide()
	
	if not actor.is_on_floor():
		if actor.velocity.y < 0:
			return jump
		elif actor.velocity.y > 0:
			return fall
	
	if actor.input.horizontal_input_direction == 0 or actor.input_locked:
		return idle
	
	return null
