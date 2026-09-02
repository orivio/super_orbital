class_name FallState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var jump: JumpState = $"../Jump"
@onready var dash: DashState = $"../Dash"
@onready var float_state: FloatState = $"../Float"


func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	actor.animation_tree.set("parameters/jump/blend_position", actor.velocity.y)
	return null


func physics_process(delta: float) -> State:
	
	actor.velocity.y += actor.movement_settings.fall_gravity_acceleration * delta
	
	if actor.input.horizontal_direction == 0 or actor.input_locked:
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			actor.velocity.x = 0
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.air_friction)
	else:
		var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_direction
		actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.air_acceleration)
	
	var did_dash: bool = false
	var did_grav_switch: bool = false
	if actor.can_jump() and not actor.input_locked:
		actor.do_jump()
	elif actor.can_dash() and not actor.input_locked:
		actor.do_dash()
		did_dash = true
	elif actor.can_grav_switch() and not actor.input_locked:
		actor.do_grav_switch()
		did_grav_switch = true
	
	actor.move_and_slide()
	
	if did_dash:
		return dash
	if did_grav_switch:
		return float_state
	
	if actor.is_on_floor():
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			return idle
		else:
			return walk
	else:
		if actor.velocity.y < 0:
			return jump
	
	
	return null
