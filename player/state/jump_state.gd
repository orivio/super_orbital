class_name JumpState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var fall: FallState = $"../Fall"
@onready var dash: DashState = $"../Dash"
@onready var float_state: FloatState = $"../Float"
@onready var black_hole: BlackHoleState = $"../BlackHole"

var still_jumping_up: bool
var coming_from_dash: bool = false


func enter() -> void:
	still_jumping_up = true
	if not actor.input.jump_down:
		still_jumping_up = false
	if coming_from_dash:
		still_jumping_up = true


func exit() -> void:
	still_jumping_up = true
	coming_from_dash = false


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	actor.animation_tree.set("parameters/jump/blend_position", actor.velocity.y)
	return null


func physics_process(delta: float) -> State:
	
	if still_jumping_up:
		actor.velocity.y += actor.movement_settings.normal_gravity_acceleration * delta
		if actor.input.jump_released or actor.input_locked:
			still_jumping_up = false
	else:
		actor.velocity.y += actor.movement_settings.peak_gravity_acceleration * delta
	
	if actor.input.horizontal_direction == 0 or actor.input_locked:
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			actor.velocity.x = 0
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, delta * actor.movement_settings.air_friction)
	else:
		var move_speed: float = actor.movement_settings.walk_speed * actor.input.horizontal_direction
		actor.velocity.x = move_toward(actor.velocity.x, move_speed, delta * actor.movement_settings.air_acceleration)
	
	actor.ceiling_clip_nudge()
	actor.wall_clip_nudge()
	
	var did_dash: bool = false
	var did_grav_switch: bool = false
	var did_enter_blackhole: bool = false
	if actor.can_dash() and not actor.input_locked:
		actor.do_dash()
		did_dash = true
	elif actor.can_grav_switch() and not actor.input_locked:
		actor.do_grav_switch()
		did_grav_switch = true
	elif actor.current_blackhole:
		did_enter_blackhole = true
	
	actor.move_and_slide()
	
	if did_dash:
		return dash
	if did_grav_switch:
		actor.anim_playback.travel("float")
		return float_state
	if did_enter_blackhole:
		actor.anim_playback.travel("black_hole")
		return black_hole
	
	
	if actor.is_on_floor():
		if abs(actor.velocity.x) < actor.movement_settings.minimum_movement_threshold:
			actor.anim_playback.travel("idle")
			return idle
		else:
			actor.anim_playback.travel("run")
			return walk
	else:
		if actor.velocity.y > 0:
			return fall
	
	
	return null
