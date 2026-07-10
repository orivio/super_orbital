class_name StateDash extends PlayerState

var dash_timer: float
var gravity_switch_pressed: bool

@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var idle_state: PlayerState = $"../Idle"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("dash")
	var y_axis = Input.get_axis("dash_up", "dash_down")
	if y_axis != 0:
		player.base_velocity.y = y_axis * player.movement_settings.dash_velocity * 0.6
		player.base_velocity.x = 0
		if y_axis > 0:
			player.dash_effect(Vector2.UP)
		elif y_axis < 0:
			player.dash_effect(Vector2.DOWN)
	else:
		player.base_velocity.x = player.facing * player.movement_settings.dash_velocity
		player.base_velocity.y = 0
		if player.base_velocity.x > 0:
			player.dash_effect(Vector2.RIGHT)
		elif player.base_velocity.x < 0:
			player.dash_effect(Vector2.LEFT)
	
	player.has_gravity = false
	player.can_dash = false
	
	if player.direction < 0:
		player.sprite.flip_h = true
	elif player.direction > 0:
		player.sprite.flip_h = false

	dash_timer = 0

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(delta: float) -> PlayerState:
	
	dash_timer += delta
	
	if gravity_switch_pressed and not player.is_on_floor() and player.can("gravity_switch"):
		gravity_switch_pressed = false
		return float_state
	
	if player.is_on_wall():
		return idle_state
	
	if dash_timer >= player.movement_settings.dash_time:
		if !player.is_on_floor():
			return fall_state
		
		if player.direction == 0:
			return walk_state
		else:
			return idle_state
	
	return null
