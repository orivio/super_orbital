class_name StateFall extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var dash_state: PlayerState = $"../Dash"

func enter() -> void:
	player.update_animation("fall")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.velocity.x = player.direction * player_movement_settings.move_speed * player_movement_settings.air_speed_multiplier
	
	# TODO: Switch sprite flippings
	
	if player.direction < 0:
		player.sprite.flip_h = false
	elif player.direction > 0:
		player.sprite.flip_h = true
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		return dash_state
	
	return null
