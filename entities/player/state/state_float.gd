class_name StateFloat extends PlayerState

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"

func enter() -> void:
	player.update_animation("float")
	player.has_gravity = false

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return walk_state
	
	if player.is_on_wall():
		return fall_state
	
	if Input.is_action_just_pressed("gravity_switch"):
		if player.velocity.y > 0:
			return fall_state
		else:
			return jump_state
	
	for black_hole: BlackHole in PhysicsManager.black_holes:
		var direction: Vector2 = black_hole.global_position - player.global_position
		var distance: float = direction.length_squared()
		var velocity: Vector2 = PhysicsManager.GRAVITY_CONSTANT * (direction.normalized() / distance) * black_hole.mass / player.movement_settings.mass
		
		player.velocity += velocity
	return null
