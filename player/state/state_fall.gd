class_name StateFall extends PlayerState

# Temporary solution
var dash_pressed: bool
var gravity_switch_pressed: bool

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.stop_animation()
	player.has_gravity = true

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("dash"):
		dash_pressed = true
	elif event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	
	if player.base_velocity.y <= 49 and player.base_velocity.y >= 0:
		player.sprite.frame = 27
	elif player.base_velocity.y <= 149 and player.base_velocity.y >= 50:
		player.sprite.frame = 28
	elif player.base_velocity.y <= 249 and player.base_velocity.y >= 150:
		player.sprite.frame = 29
	elif player.base_velocity.y <= 399 and player.base_velocity.y >= 250:
		player.sprite.frame = 30
	elif player.base_velocity.y <= 899 and player.base_velocity.y >= 400:
		player.sprite.frame = 31
	else:
		pass
	
	return null

func physics_process(_delta: float) -> PlayerState:
	
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
	
	if dash_pressed and player.can("dash"):
		dash_pressed = false
		return dash_state
	
	if gravity_switch_pressed and player.can("gravity_switch"):
		gravity_switch_pressed = false
		return float_state
	
	return null
