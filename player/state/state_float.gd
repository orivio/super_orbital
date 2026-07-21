class_name StateFloat extends PlayerState

var entry_velocity: Vector2
var gravity_switch_pressed: bool
var throw_wrench_pressed: bool
var x_axis: float
var y_axis: float
var just_collided_x: bool = false
var just_collided_bottom: bool = false
var just_collided_top: bool = false
var was_on_wall: bool = false

var set_to_return_idle_state: bool = false
var set_to_return_walk_state: bool = false
var set_to_return_fall_state: bool = false
var has_bounced_y: bool = false

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
	
	player.gravity_switch_counter += 1
	player.gravity_switch_timer = player.movement_settings.gravity_switch_cooldown
	player.can_enter_nograv = false
	
	gravity_switch_pressed = false
	throw_wrench_pressed = false
	set_to_return_idle_state = false
	set_to_return_walk_state = false
	set_to_return_fall_state = false

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	elif event.is_action_pressed("throw_wrench"):
		throw_wrench_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	x_axis = Input.get_axis("left", "right")
	y_axis = Input.get_axis("up", "down")
	return null

func physics_process(_delta: float) -> PlayerState:
	#print("Frame start")
	
	var on_wall = player.is_on_wall()
	
	if player.is_on_floor() and player.base_velocity.y > 0.001 and not just_collided_bottom:
		just_collided_bottom = true
		if player.base_velocity.y > (player.movement_settings.float_bounce_min_velocity):
			GameManager.impact()
			player.base_velocity.y = entry_velocity.y * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.y = player.base_velocity.y
			player.spawn_impact_cloud(player.global_position + Vector2.DOWN * player.get_half_height(), 0)
			has_bounced_y = true
			get_tree().create_timer(0.1).timeout.connect(func():
				has_bounced_y = false
			)
			return null
		else:
			if player.direction == 0:
				set_to_return_idle_state = true
			else:
				set_to_return_walk_state = true
	elif player.is_on_floor() and not just_collided_bottom:
		if player.direction == 0:
			set_to_return_idle_state = true
		else:
			set_to_return_walk_state = true
	elif not player.is_on_floor() and just_collided_bottom:
		just_collided_bottom = false
		
	
	if player.is_on_ceiling() and player.base_velocity.y < -0.001 and not just_collided_top:
		just_collided_top = true
		if player.base_velocity.y > (player.movement_settings.float_bounce_min_velocity):
			GameManager.impact()
			player.base_velocity.y = entry_velocity.y * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.y = player.base_velocity.y
			has_bounced_y = true
			get_tree().create_timer(0.1).timeout.connect(func():
				has_bounced_y = false
			)
		else:
			set_to_return_fall_state = true
	elif not player.is_on_ceiling() and just_collided_top:
		just_collided_top = false
	
	if on_wall and not was_on_wall and abs(player.base_velocity.x) > 0.001:
		if player.base_velocity.x > (player.movement_settings.float_bounce_min_velocity):
			GameManager.impact()
			player.base_velocity.x = entry_velocity.x * -1 * player.movement_settings.float_bounce_decay_factor
			entry_velocity.x = player.base_velocity.x
			player.sprite.flip_h = not player.sprite.flip_h
			if player.base_velocity.x < 0:
				player.spawn_impact_cloud(player.global_position + Vector2.RIGHT * player.get_half_width(), -90)
			else:
				player.spawn_impact_cloud(player.global_position + Vector2.LEFT * player.get_half_width(), 90)
		else:
			if not has_bounced_y:
				if player.is_on_floor():
					return idle_state
				else:
					return fall_state
		just_collided_x = true
	elif not on_wall and was_on_wall:
		just_collided_x = false
	
	if set_to_return_idle_state:
		return idle_state
	if set_to_return_walk_state:
		return walk_state
	if set_to_return_fall_state:
		return fall_state
	
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
	
	was_on_wall = on_wall
	
	
	if player.base_velocity.y <= -500:
		player.sprite.frame = 33
	elif player.base_velocity.y >= 500:
		player.sprite.frame = 34
	
	if player.base_velocity.x > 500:
		player.sprite.flip_h = false
		player.sprite.frame = 32
	elif player.base_velocity.x < -500:
		player.sprite.flip_h = true
		player.sprite.frame = 32
		
	return null
