class_name FloatState
extends State

var movement_direction: Vector2

@onready var idle: IdleState = $"../Idle"
@onready var walk: WalkState = $"../Walk"
@onready var jump: JumpState = $"../Jump"
@onready var fall: FallState = $"../Fall"


func enter() -> void:
	movement_direction = actor.velocity
	actor.start_afterimage_effect()
	actor.anim_playback.start("float")


func exit() -> void:
	actor.stop_afterimage_effect()


func input(_event: InputEvent) -> State:
	return null


func process(_delta: float) -> State:
	actor.animation_tree.set("parameters/float/blend_position", actor.velocity)
	return null


func physics_process(delta: float) -> State:
	var gravity_on: bool = false
	if actor.grav_switch_buffer and not actor.input_locked:
		gravity_on = true

	# I think move_and_collide is the best option here because you can only 
	# really wall bounce in this state, but I could be wrong.
	var collision_info: KinematicCollision2D = actor.move_and_collide(actor.velocity * delta)
	
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
	
	if collision_info:
		# Bounce off the surface
		actor.velocity = actor.velocity.bounce(collision_info.get_normal())
		movement_direction = actor.velocity
		GameManager.hitstop(actor.movement_settings.float_wall_bounce_hitstop)
		GameManager.camera_shake_directional(collision_info.get_normal(), actor.movement_settings.float_wall_bounce_camera_shake_strength)
	
	return null
