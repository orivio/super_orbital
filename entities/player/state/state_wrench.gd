class_name StateWrench extends PlayerState

var entry_velocity = 0

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("wrench")
	entry_velocity = player.velocity
	if not player.is_on_floor():
		player.velocity = entry_velocity * -1

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor():
		player.velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.velocity.y
		#return float_state
	
	if player.is_on_ceiling():
		player.velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.velocity.y
		#return float_state
	
	if player.is_on_wall():
		player.velocity.x = entry_velocity.x * -1
		entry_velocity.x = player.velocity.x
		player.sprite.flip_h = not player.sprite.flip_h
		#return float_state
	
	if Input.is_action_just_pressed("gravity_switch"):
		if player.velocity.y > 0:
			return fall_state
		else:
			return jump_state
		return float_state
	
	return null
