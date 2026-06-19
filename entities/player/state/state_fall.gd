class_name StateFall extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("fall")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	
	#if player.base_velocity.y <= 99 and player.base_velocity.y >= 0:
		#player.sprite.frame = 9
	#elif player.base_velocity.y <= 199 and player.base_velocity.y >= 100:
		#player.sprite.frame = 10
	#elif player.base_velocity.y <= 399 and player.base_velocity.y >= 200:
		#player.sprite.frame = 11
	#elif player.base_velocity.y <= 599 and player.base_velocity.y >= 400:
		#player.sprite.frame = 12
	#elif player.base_velocity.y <= 899 and player.base_velocity.y >= 600:
		#player.sprite.frame = 13
	#else:
		#print(player.base_velocity.y)
	
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.base_velocity.x = player.direction * player.movement_settings.move_speed * player.movement_settings.air_speed_multiplier
	
	if player.direction < 0:
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.sprite.flip_h = false
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		return dash_state
	
	if Input.is_action_just_pressed("gravity_switch") and player.can_gravity_switch:
		return float_state
	
	return null
