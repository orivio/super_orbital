class_name FloatState
extends State

var movement_direction: Vector2

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var jump: JumpState = $"../Jump"
@onready var fall: FallState = $"../Fall"


func enter() -> void:
	movement_direction = actor.velocity


func exit() -> void:
	pass


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	var gravity_on: bool = false
	if actor.input.grav_switch_pressed and not actor.input_locked:
		gravity_on = true
	
	actor.move_and_slide()
	
	
	if gravity_on:
		actor.turn_on_gravity()
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
	
	if actor.is_on_wall():
		# Bounce off the wall
		GameManager.hitstop(actor.movement_settings.float_wall_bounce_hitstop)
		GameManager.camera_shake(actor.movement_settings.float_wall_bounce_camera_shake_strength)
		movement_direction.x *= -1
		actor.velocity = movement_direction
	
	return null
