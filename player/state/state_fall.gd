class_name StateFall extends PlayerState

# Temporary solution
var dash_pressed: bool
var gravity_switch_pressed: bool
var jump_pressed: bool

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"
@onready var jump_state: PlayerState = $"../Jump"

func enter() -> void:
	player.has_gravity = true
	dash_pressed = false
	gravity_switch_pressed = false
	jump_pressed = false

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("dash"):
		dash_pressed = true
	elif event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	elif event.is_action_pressed("jump"):
		jump_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	
	if player.base_velocity.y <= 49 and player.base_velocity.y >= 0:
		player.sprite.frame = 51
	elif player.base_velocity.y <= 149 and player.base_velocity.y >= 50:
		player.sprite.frame = 52
	elif player.base_velocity.y <= 249 and player.base_velocity.y >= 150:
		player.sprite.frame = 52
	elif player.base_velocity.y <= 399 and player.base_velocity.y >= 250:
		player.sprite.frame = 53
	elif player.base_velocity.y <= 899 and player.base_velocity.y >= 400:
		player.sprite.frame = 53
	else:
		pass
	
	return null

func physics_process(_delta: float) -> PlayerState:
	
	player.base_velocity.x = player.direction * player.movement_settings.move_speed * player.movement_settings.air_speed_multiplier
	
	if player.direction < 0:
		player.facing = -1
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.facing = 1
		player.sprite.flip_h = false
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if player.is_on_floor_buffered and jump_pressed and player.can("jump"):
		jump_pressed = false
		player.base_velocity.y = -player.movement_settings.jump_velocity
		return jump_state
	
	if dash_pressed and player.can("dash"):
		dash_pressed = false
		return dash_state
	
	if gravity_switch_pressed and player.can("gravity_switch"):
		gravity_switch_pressed = false
		return float_state
	
	return null
