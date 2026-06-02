class_name StateJump extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.velocity.y = -player.movement_settings.jump_velocity
	player.update_animation("jump")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.velocity.x = player.direction * player.movement_settings.move_speed * player.movement_settings.air_speed_multiplier
	
	# TODO: Switch sprite flippings
	
	if player.direction < 0:
		player.sprite.flip_h = false
	elif player.direction > 0:
		player.sprite.flip_h = true
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		return dash_state
	
	if Input.is_action_just_pressed("gravity_switch"):
		return float_state
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if player.velocity.y > 0:
		return fall_state
	
	return null
