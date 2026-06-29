class_name StateIdle extends PlayerState

@onready var walk_state: PlayerState = $"../Walk"
@onready var jump_state: PlayerState = $"../Jump"

func enter() -> void:
	player.update_animation("idle")
	player.has_gravity = true

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	player.base_velocity.x = 0
	
	if player.direction != 0:
		return walk_state
	
	if player.jump_buffer and player.can("jump"):
		return jump_state
	
	return null
