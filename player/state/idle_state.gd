class_name IdleState
extends State

@onready var walk: WalkState = $"../Walk"
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
	if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
		actor.velocity.x = 0
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.ground_friction)
	
	actor.velocity.y += actor.movement_settings.normal_gravity_acceleration * delta
		
	if actor.can_jump() and not actor.input_locked:
		actor.do_jump()
	
	actor.move_and_slide()
	
	if not actor.is_on_floor():
		if actor.velocity.y < 0:
			return jump
		elif actor.velocity.y > 0:
			return fall
	
	if actor.input.horizontal_input_direction != 0 and not actor.input_locked:
		return walk
	
	return null
