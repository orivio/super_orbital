class_name StateFloat extends PlayerState

var entry_velocity = 0

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var wrench_state: PlayerState = $"../Wrench"

func enter() -> void:
	player.update_animation("float")
	player.has_gravity = false
	entry_velocity = player.velocity

func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor():
		player.velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.velocity.y
	#	if player.direction == 0:
	#		return idle_state
	#	else:
	#		return walk_state
	
	if player.is_on_ceiling():
		player.velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.velocity.y
	
	if player.is_on_wall():
		player.velocity.x = entry_velocity.x * -1
		entry_velocity.x = player.velocity.x
		player.sprite.flip_h = not player.sprite.flip_h
	
	if Input.is_action_just_pressed("gravity_switch"):
		player.has_gravity = true
	
	if player.has_gravity:
		if player.velocity.y > 0:
			return fall_state
		else:
			return jump_state
		#return fall_state #not returning fall state despite having gravity??
	
	if Input.is_action_just_pressed("throw_wrench"):
		var x_wrench = Input.get_axis("wrench_left", "wrench_right")
		var y_wrench = Input.get_axis("wrench_up", "wrench_down")
		var wrench_direction = Vector2(x_wrench, y_wrench)
		if wrench_direction != Vector2.ZERO:
			player.velocity = wrench_direction.normalized() * player.movement_settings.wrench_velocity
			if player.velocity.x > 0:
				player.sprite.flip_h = false
			elif player.velocity.x < 0:
				player.sprite.flip_h = true
		return wrench_state
		#E = mc^2 - Rayyan Khan
	
	for black_hole: BlackHole in PhysicsManager.black_holes:
		var direction: Vector2 = black_hole.global_position - player.global_position
		var distance: float = direction.length_squared()
		var velocity: Vector2 = PhysicsManager.GRAVITY_CONSTANT * (direction.normalized() / distance) * black_hole.mass / player.movement_settings.mass
		
		player.velocity += velocity
	return null
