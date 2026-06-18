class_name StateWalk extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var jump_state: PlayerState = $"../Jump"
@onready var fall_state: PlayerState = $"../Fall"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("walk")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.base_velocity.x = player.direction * player.movement_settings.move_speed
	
	if player.direction < 0:
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.sprite.flip_h = false
	else:
		return idle_state
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		return dash_state
	
	if player.jump_buffer and player.can_jump:
		return jump_state
	
	if Input.is_action_just_pressed("gravity_switch") and player.can_gravity_switch:
		player.has_gravity = false
		return float_state # why no work :(
		#i added the float state variable at the top and all but it doesnt work
		# no errors thrown tho
	
	if player.velocity.y > 0:
		return fall_state
	
	return null
