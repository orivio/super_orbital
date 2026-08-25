class_name StateBlackHole
extends PlayerState


var left_blackhole: bool = false
var gravity_switch_pressed: bool = false
var change_orbit_pressed: bool = false
var distance_to_black_hole: float
var black_hole_center: Vector2

@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var float_state: PlayerState = $"../Float"
@onready var walk_state: PlayerState = $"../Walk"

func _ready() -> void:
	GameManager.player_left_blackhole.connect(_on_player_left_blackhole)

func enter() -> void:
	left_blackhole = false
	player.has_gravity = false
	gravity_switch_pressed = false

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	if event.is_action_pressed("change_orbit"):
		change_orbit_pressed = true
		print("orbit changed")
	return null

func process(_delta: float) -> PlayerState:
	return null

func physics_process(_delta: float) -> PlayerState:
	
	for black_hole: BlackHole in PhysicsManager.black_holes:
		if black_hole.influencing_player:
			var direction: Vector2 = black_hole.global_position - player.global_position
			var distance: float = direction.length()
			black_hole_center = black_hole.global_position
			distance_to_black_hole = distance
			
			player.base_velocity = 100000. * Vector2(-direction.y, direction.x).normalized() / distance + direction * Input.get_axis("down", "up")
			
			if change_orbit_pressed == true:
				direction *= -1
				change_orbit_pressed = false
				print(direction)
	
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
	
	if player.base_velocity.x > 0:
		player.facing = 1
		player.sprite.flip_h = false
	elif player.base_velocity.x < 0:
		player.facing = -1
		player.sprite.flip_h = true
	
	return null

func _on_player_left_blackhole() -> void:
	left_blackhole = true
