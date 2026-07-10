class_name StateFloat extends PlayerState

var entry_velocity: Vector2
var gravity_switch_pressed: bool
var throw_wrench_pressed: bool
var x_axis: float
var y_axis: float
var just_collided_x: bool = false
var just_collided_y: bool = false

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var wrench_state: PlayerState = $"../Wrench"

func enter() -> void:
	player.stop_animation();
	player.has_gravity = false
	
	if player.base_velocity.length_squared() < (player.movement_settings.float_min_velocity ** 2):
		if abs(player.base_velocity.length_squared()) < 0.00001:
			entry_velocity = Vector2.UP * player.movement_settings.float_min_velocity
		else:
			entry_velocity = player.base_velocity.normalized() * player.movement_settings.float_min_velocity
	else:
		entry_velocity = player.base_velocity
	
	player.base_velocity = entry_velocity

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	elif event.is_action_pressed("throw_wrench"):
		throw_wrench_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	x_axis = Input.get_axis("wrench_left", "wrench_right")
	y_axis = Input.get_axis("wrench_up", "wrench_down")
	return null

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor() and not just_collided_y:
		if player.base_velocity.length_squared() > (player.movement_settings.float_bounce_min_velocity ** 2):
			GameManager.impact()
			player.base_velocity.y = entry_velocity.y * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.y = player.base_velocity.y
			player.spawn_impact_cloud(player.global_position + Vector2.DOWN * player.get_half_height(), 0)
		else:
			if player.direction == 0:
				return idle_state
			else:
				return walk_state
		just_collided_y = true
	else:
		just_collided_y = false
	
	if player.is_on_ceiling() and not just_collided_y:
		if player.base_velocity.length_squared() > (player.movement_settings.float_bounce_min_velocity ** 2):
			GameManager.impact()
			player.base_velocity.y = entry_velocity.y * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.y = player.base_velocity.y
		else:
			return fall_state
		just_collided_y = true
	else:
		just_collided_y = false
	
	if player.is_on_wall() and not just_collided_x:
		if player.base_velocity.length_squared() > (player.movement_settings.float_bounce_min_velocity ** 2):
			GameManager.impact()
			player.base_velocity.x = entry_velocity.x * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.x = player.base_velocity.x
			player.sprite.flip_h = not player.sprite.flip_h
			if player.base_velocity.x < 0:
				player.spawn_impact_cloud(player.global_position + Vector2.RIGHT * player.get_half_width(), -90)
			else:
				player.spawn_impact_cloud(player.global_position + Vector2.LEFT * player.get_half_width(), 90)
		else:
			return fall_state
		just_collided_x = true
	else:
		just_collided_x = false
	
	if gravity_switch_pressed and player.can("gravity_switch"):
		gravity_switch_pressed = false
		player.has_gravity = true
	
	if player.has_gravity:
		if player.base_velocity.y > 0:
			return fall_state
		else:
			return jump_state
	
	if throw_wrench_pressed and player.can("throw_wrench"):
		throw_wrench_pressed = false
		var x_wrench = x_axis
		var y_wrench = y_axis
		var wrench_direction = Vector2(x_wrench, y_wrench)
		# print(wrench_direction)
		if wrench_direction != Vector2.ZERO:
			player.base_velocity = -wrench_direction.normalized() * player.base_velocity.length()
			if player.base_velocity.x > 0:
				player.sprite.flip_h = false
			elif player.base_velocity.x < 0:
				player.sprite.flip_h = true
		return wrench_state
		#E = mc^2 - Rayyan Khan
	
	for black_hole: BlackHole in PhysicsManager.black_holes:
		var direction: Vector2 = black_hole.global_position - player.global_position
		var distance: float = direction.length_squared()
		var velocity: Vector2 = PhysicsManager.GRAVITY_CONSTANT * (direction.normalized() / distance) * black_hole.mass / player.movement_settings.mass
		
		player.base_velocity += velocity
	return null
