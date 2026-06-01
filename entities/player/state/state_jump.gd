class_name StateJump extends PlayerState

@export var move_speed: float
@export var jump_velocity: float

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"

func enter() -> void:
	player.velocity.y = -jump_velocity
	player.update_animation("jump")

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	player.velocity.x = player.direction * move_speed
	
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
	
	#if player.velocity.y > 0:
	#	return fall_state
	
	return null
