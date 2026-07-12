class_name StateJump extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

var jump_released: bool
var dash_pressed: bool
var gravity_switch_pressed: bool

func enter() -> void:
	player.stop_animation();
	player.has_gravity = true
	player.base_velocity.y = -player.movement_settings.jump_velocity

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_released("jump"):
		jump_released = true
	elif event.is_action_pressed("dash"):
		dash_pressed = true
	elif event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	
	if player.base_velocity.y >= -199 and player.base_velocity.y <= 0:
		player.sprite.frame = 21
	elif player.base_velocity.y >= -399 and player.base_velocity.y <= -200:
		player.sprite.frame = 23
	elif player.base_velocity.y > -899 and player.base_velocity.y <= -400:
		player.sprite.frame = 25
	else:
		pass
		# print(player.base_velocity.y)
	
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.base_velocity.x = player.direction * player.movement_settings.move_speed * player.movement_settings.air_speed_multiplier
	
	if jump_released:
		jump_released = false
		player.base_velocity.y = 0
	
	if player.direction < 0:
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.sprite.flip_h = false
	
	if dash_pressed and player.can("dash"):
		dash_pressed = false
		return dash_state
	
	if gravity_switch_pressed and player.can("gravity_switch"):
		gravity_switch_pressed = false
		return float_state
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if player.is_on_ceiling():
		player.base_velocity.y = 0
	
	if player.base_velocity.y > 0:
		return fall_state
	
	return null
