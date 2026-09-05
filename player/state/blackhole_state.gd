class_name BlackHoleState
extends State

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var jump: JumpState = $"../Jump"
@onready var fall: FallState = $"../Fall"
@onready var float_state: FloatState = $"../Float"

func enter() -> void:
	pass


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	
	var did_leave_blackhole: bool
	var did_grav_switch: bool = false
	if not actor.current_blackhole:
		did_leave_blackhole = true
	elif actor.can_grav_switch() and not actor.input_locked:
		actor.do_grav_switch()
		did_grav_switch = true
	
	actor.move_and_slide()
	
	if did_leave_blackhole:
		return exit_to_normal_state()
	if did_grav_switch:
		actor.anim_playback.travel("float")
		return float_state
	
	return null


func exit_to_normal_state() -> State:
	if actor.floorcaster.is_colliding():
		if actor.input.horizontal_direction == 0 or actor.input_locked:
			actor.anim_playback.travel("idle")
			return idle
		else:
			actor.anim_playback.travel("run")
			return walk
	else:
		if actor.velocity.y >= 0:
			actor.anim_playback.travel("jump")
			return fall
		else:
			jump.coming_from_dash = true
			actor.anim_playback.travel("jump")
			return jump
