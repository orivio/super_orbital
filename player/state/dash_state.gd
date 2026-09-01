class_name DashState
extends State

var dash_timer: float
var dash_2_timer: float
var in_second_phase: bool

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var fall: FallState = $"../Fall"
@onready var jump: JumpState = $"../Jump"


func enter() -> void:
	dash_timer = 0
	dash_2_timer = 0
	in_second_phase = false
	actor.start_afterimage_effect()


func exit() -> void:
	actor.stop_afterimage_effect()


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	# This dash mechanic was inspired by Celeste in that a dash has two phases:
	# Phase 1:
	# 	You dash in the direction you intended for a certain amount of time at 
	#	full speed.
	# Phase 2:
	# 	You keep moving in the same direction, but with less speed. During this 
	# 	phase, you can influence your movement a little bit more, and also exit 
	# 	the dash using a few different methods.
	
	var end_dash: bool = false
	if dash_timer > actor.movement_settings.dash_time:
		if dash_2_timer > actor.movement_settings.dash_exit_time:
			end_dash = true
		else:
			dash_2_timer += delta
			if actor.input.jump_pressed:
				# Cancel the dash
				end_dash = true
				actor.velocity = Vector2.ZERO
			if not in_second_phase:
				in_second_phase = true
				actor.velocity *= actor.movement_settings.dash_exit_diminish
	else:
		dash_timer += delta
	
	actor.move_and_slide()
	
	if end_dash:
		if actor.floorcaster.is_colliding():
			if actor.input.horizontal_direction == 0 or actor.input_locked:
				return idle
			else:
				return walk
		else:
			if actor.velocity.y >= 0:
				return fall
			else:
				jump.coming_from_dash = true
				return jump
	
	return null
