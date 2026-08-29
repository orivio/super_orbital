class_name JumpState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var fall: FallState = $"../Fall"

var still_jumping_up: bool


func enter() -> void:
	still_jumping_up = true
	if not actor.input.jump_down:
		still_jumping_up = false


func exit() -> void:
	still_jumping_up = true


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	
	if still_jumping_up:
		actor.velocity.y += actor.movement_settings.normal_gravity_acceleration * delta
		if actor.input.jump_released or actor.input_locked:
			still_jumping_up = false
	else:
		actor.velocity.y += actor.movement_settings.peak_gravity_acceleration * delta
	
	if actor.input.horizontal_input_direction == 0 or actor.input_locked:
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			actor.velocity.x = 0
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.air_friction)
	else:
		var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_input_direction
		actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.air_acceleration)
	
	if actor.velocity.y < -actor.movement_settings.ceiling_clip_min_velocity:
		actor.ceiling_clip_nudge()
	
	actor.move_and_slide()
	
	
	if actor.is_on_floor():
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			return idle
		else:
			return walk
	else:
		if actor.velocity.y > 0:
			return fall
	
	
	return null
