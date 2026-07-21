class_name StateBlackHole
extends PlayerState


var left_blackhole = false
var gravity_switch_pressed = false

@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var float_state: PlayerState = $"../Float"
@onready var walk_state: PlayerState = $"../Walk"


func enter() -> void:
	GameManager.player_left_blackhole.connect(_on_player_left_blackhole)
	left_blackhole = false
	player.has_gravity = false
	gravity_switch_pressed = false

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	
	for black_hole: BlackHole in PhysicsManager.black_holes:
		if black_hole.influencing_player:
			var direction: Vector2 = black_hole.global_position - player.global_position
			var distance: float = direction.length()
			var velocity: Vector2 = PhysicsManager.GRAVITY_CONSTANT * (direction.normalized() / distance) * black_hole.mass / player.movement_settings.mass
			
			player.base_velocity.x += velocity.x
			player.base_velocity.y += velocity.y * GameManager.time_scale
	
	if left_blackhole:
		left_blackhole = false
		player.has_gravity = true
		if player.base_velocity.y > 0:
			return jump_state
		elif player.base_velocity.y < 0:
			return fall_state
		else:
			return walk_state
		
	if gravity_switch_pressed:
		gravity_switch_pressed = false
		GameManager.player_leave_blackhole()
		player.has_gravity = false
		return float_state
	
	return null

func _on_player_left_blackhole() -> void:
	left_blackhole = true
