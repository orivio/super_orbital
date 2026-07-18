class_name StateWalk extends PlayerState

var dash_pressed: bool
var gravity_switch_pressed: bool

@onready var idle_state: PlayerState = $"../Idle"
@onready var jump_state: PlayerState = $"../Jump"
@onready var fall_state: PlayerState = $"../Fall"
@onready var dash_state: PlayerState = $"../Dash"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("run")
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
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.base_velocity.x = player.direction * player.movement_settings.move_speed
	
	if player.direction < 0:
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.sprite.flip_h = false
	else:
		return idle_state
	
	if dash_pressed and player.can("dash"):
		dash_pressed = false
		return dash_state
	
	if player.jump_buffer and player.can("jump"):
		player.base_velocity.y = -player.movement_settings.jump_velocity
		return jump_state
	
	# The player should not be able to gravity switch when walking.
	
	if not player.is_on_floor():
		if player.base_velocity.y > 0:
			return fall_state
		else:
			return jump_state
	
	return null
