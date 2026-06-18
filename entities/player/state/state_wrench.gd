class_name StateWrench extends PlayerState

var entry_velocity = 0

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("wrench")
	entry_velocity = player.base_velocity
	if not player.is_on_floor():
		player.base_velocity = entry_velocity * -1

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor():
		GameManager.impact()
		player.base_velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.base_velocity.y
		#return float_state
	
	if player.is_on_ceiling():
		GameManager.impact()
		player.base_velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.base_velocity.y
		#return float_state
	
	if player.is_on_wall():
		GameManager.impact()
		player.base_velocity.x = entry_velocity.x * -1
		entry_velocity.x = player.base_velocity.x
		player.sprite.flip_h = not player.sprite.flip_h
		#return float_state
	
	if Input.is_action_just_pressed("gravity_switch") and player.can_gravity_switch:
		player.has_gravity = true
	
	if player.has_gravity:
		if player.base_velocity.y > 0:
			return fall_state
		else:
			return jump_state
	
	return null
