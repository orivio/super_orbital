class_name DashState
extends State

var dash_timer: float

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var fall: FallState = $"../Fall"
@onready var jump: JumpState = $"../Jump"


func enter() -> void:
	dash_timer = 0


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	dash_timer += delta
	var end_dash: bool = false
	if dash_timer > actor.movement_settings.dash_time:
		end_dash = true
	
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
				return jump
	
	return null
