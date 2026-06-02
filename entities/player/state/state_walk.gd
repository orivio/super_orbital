class_name StateWalk extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var jump_state: PlayerState = $"../Jump"
@onready var fall_state: PlayerState = $"../Fall"
@onready var dash_state: PlayerState = $"../Dash"

func enter() -> void:
	player.update_animation("walk")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.velocity.x = player.direction * player_movement_settings.move_speed
	
	# TODO: Switch sprite flippings
	
	if player.direction < 0:
		player.sprite.flip_h = false
	elif player.direction > 0:
		player.sprite.flip_h = true
	else:
		return idle_state
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		return dash_state
		return dash_state
	
	if Input.is_action_just_pressed("jump"):
		return jump_state
	
	if player.velocity.y > 0:
		return fall_state
	
	return null
