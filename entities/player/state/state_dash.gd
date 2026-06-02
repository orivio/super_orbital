class_name StateDash extends PlayerState

var dash_timer: float

@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var idle_state: PlayerState = $"../Fall"

func enter() -> void:
	player.update_animation("dash")
	player.velocity.x = player.facing * player.movement_settings.dash_velocity
	player.velocity.y = 0
	
	player.has_gravity = false
	player.can_dash = false
	
	# TODO: Fix sprite flipping
	
	if player.direction < 0:
		player.sprite.flip_h = false
	elif player.direction > 0:
		player.sprite.flip_h = true

	dash_timer = 0
	print("Dash start")

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	dash_timer += delta
	print(dash_timer, ", ", player.movement_settings.dash_time)
	
	if player.is_on_wall():
		return idle_state
	
	if dash_timer >= player.movement_settings.dash_time:
		print("Dash end")
		if !player.is_on_floor():
			return fall_state
		
		if player.direction == 0:
			return walk_state
		else:
			return idle_state
	
	return null
