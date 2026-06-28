class_name StateWrench extends PlayerState

var entry_velocity = 0
var gravity_switch_pressed: bool
var wrench_cosmetic = preload("res://systems/world/objects/wrench_cosmetic/wrench_sprite.tscn")

@onready var idle_state: PlayerState = $"../Idle"
@onready var walk_state: PlayerState = $"../Walk"
@onready var fall_state: PlayerState = $"../Fall"
@onready var jump_state: PlayerState = $"../Jump"
@onready var float_state: PlayerState = $"../Float"

func enter() -> void:
	player.update_animation("wrench")
	entry_velocity = player.base_velocity
	spawn_wrench_sprite()
	if not player.is_on_floor():
		player.base_velocity = entry_velocity * -1

func exit() -> void:
	pass

func input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("gravity_switch"):
		gravity_switch_pressed = true
	return null

func process(_delta: float) -> PlayerState:
	return null

func spawn_wrench_sprite():
	var wrench_to_spawn = wrench_cosmetic.instantiate()
	wrench_to_spawn.position = player.position
	get_tree().current_scene.add_child(wrench_to_spawn)
	await get_tree().create_timer(1.0).timeout
	wrench_to_spawn.queue_free()

func physics_process(delta: float) -> PlayerState:
	
	if player.is_on_floor():
		GameManager.impact()
		player.base_velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.base_velocity.y
		#return float_state
	
	if player.is_on_ceiling():
		GameManager.impact()
		player.base_velocity.y = entry_velocity.y * -1
		entry_velocity.y = player.base_velocity.y
		#return float_state
	
	if player.is_on_wall():
		GameManager.impact()
		player.base_velocity.x = entry_velocity.x * -1
		entry_velocity.x = player.base_velocity.x
		player.sprite.flip_h = not player.sprite.flip_h
		#return float_state
	
	if gravity_switch_pressed and player.can("gravity_switch"):
		gravity_switch_pressed = false
		player.has_gravity = true
	
	if player.has_gravity:
		if player.base_velocity.y > 0:
			return fall_state
		else:
			return jump_state
	
	return null
