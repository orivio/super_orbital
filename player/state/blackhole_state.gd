class_name BlackHoleState
extends State

var direction_clockwise: bool

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var jump: JumpState = $"../Jump"
@onready var fall: FallState = $"../Fall"
@onready var float_state: FloatState = $"../Float"

func enter() -> void:
	actor.velocity = Vector2.ZERO
	direction_clockwise = true


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
	
	if not did_leave_blackhole:
		var to_blackhole: Vector2 = actor.current_blackhole.global_position - actor.global_position
		var perpendicular_vector: Vector2
		if direction_clockwise:
			perpendicular_vector = Vector2(-to_blackhole.y, to_blackhole.x)
		perpendicular_vector += perpendicular_vector.normalized() * 180
		
		actor.velocity = perpendicular_vector
		
		actor.velocity += -to_blackhole * actor.input.vertical_direction * 0.7
	
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
