class_name Player
extends CharacterBody2D

signal player_death
signal ability_unlocked(name: String)
signal ability_locked(name: String)

const IMPACT_CLOUD = preload("res://effects/impact_cloud/impact_cloud.tscn")
const DASH_CLOUD = preload("res://effects/dash_cloud/dash_cloud.tscn")

@export var movement_settings: PlayerMovementSettings
@export var abilities: PlayerAbilities = null

var direction: float:
	set(value):
		direction = value
		if value != 0:
			facing = value
var facing: float
var has_gravity: bool
var base_velocity: Vector2
var is_dying: bool = false
var can_dash: bool = true
var can_move: bool = true
var can_enter_nograv: bool = true
var can_jump: bool = true
var can_throw_wrench: bool = true
var input_locked: bool
var death_timer: float = 0
var disabled: bool = false
var tooltips_disabled: bool = false
var jump_buffer: bool = false
var gravity_switch_counter: int = 0
var gravity_switch_timer: float = 0

var effect_nodes: Array[Node2D]


@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tooltip: Tooltip = $Tooltip
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var floor_caster: ShapeCast2D = $FloorCaster
@onready var effects: Node2D = $Effects

func _ready() -> void:
	GameManager.player = self
	ability_unlocked.connect(SaveManager._on_ability_unlocked)
	ability_locked.connect(SaveManager._on_ability_locked)
	state_machine.initialize()
	
func reset() -> void:
	has_gravity = true
	base_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	state_machine.reset()
	for effect in effects.get_children():
		if not effect.is_queued_for_deletion():
			effect.queue_free()

func _process(delta: float) -> void:
	if !input_locked:
		direction = Input.get_axis("left", "right")
	else:
		direction = 0
	
	if is_dying:
		if death_timer > 0:
			death_timer -= delta
		elif death_timer <= 0:
			death_timer = 0
			is_dying = false
			input_locked = false
			can_dash = true
			can_move = true
			can_enter_nograv = true
			can_jump = true
			can_throw_wrench = true
			player_death.emit()
			get_tree().create_timer(0.1).timeout.connect(_on_death_timeout)
	
	#if tooltips_disabled:
	#	if tooltips_timer > 0:
	#		tooltips_timer -= delta
	#	elif tooltips_timer <= 0:
	#		tooltips_disabled = false
	#		tooltips_timer = 0
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = true
		get_tree().create_timer(movement_settings.jump_buffer).timeout.connect(on_jump_buffer_timeout)
	
	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	#print(state_machine.current_state)
	if is_on_floor() and not input_locked:
		can_dash = true
		gravity_switch_counter = 0
	
	if gravity_switch_timer > 0:
		gravity_switch_timer -= delta
	elif gravity_switch_counter < 2:
		can_enter_nograv = true
	
	if has_gravity and not is_on_floor():
		var scaled_delta: float = delta * GameManager.time_scale
		
		if base_velocity.y < 0:
			base_velocity.y += movement_settings.gravity * scaled_delta
		else:
			base_velocity.y += movement_settings.gravity * movement_settings.downward_gravity_multiplier * scaled_delta
	
	velocity.x = base_velocity.x * GameManager.time_scale
	# base_velocity.y already got time scaled
	base_velocity.y = clamp(base_velocity.y, -movement_settings.max_velocity, movement_settings.max_velocity)
	velocity.y = base_velocity.y * GameManager.time_scale

	move_and_slide()
	state_machine.physics_process(delta)
	
	if is_on_floor() and has_gravity and not state_machine.current_state is StateJump and not state_machine.current_state is StateFloat:
		base_velocity.y = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		print("From Player: Dash pressed")
		print(event)
		print(event.as_text())
		print()
	state_machine.input(event)

func load_abilities() -> void:
	if not abilities:
		abilities = SaveManager.get_save_file().player_abilities

func update_animation(animation: String) -> void:
	if animation_player.current_animation != animation:
		animation_player.play(animation)

func stop_animation() -> void:
	animation_player.stop()

func show_tooltip(message: String) -> void:
	tooltip.show_tooltip(message)

func hide_tooltip() -> void:
	tooltip.hide_tooltip()


func die() -> void:
	has_gravity = true
	is_dying = true
	can_dash = false
	can_move = false
	can_jump = false
	can_throw_wrench = false
	can_enter_nograv = false
	input_locked = true
	#update_animation("hit")
	GameManager.impact()
	death_timer = 0.4
	tooltips_disabled = true

func on_jump_buffer_timeout() -> void:
	jump_buffer = false

func get_half_height() -> float:
	return collider.shape.get_rect().size.y / 2

func get_half_width() -> float:
	return collider.shape.get_rect().size.x / 2 + 10

func _on_death_timeout() -> void:
	tooltips_disabled = false
	reset()

func teleport_to_ground(target: Vector2) -> void:
	global_position = target
	#print("Teleporting player to: ", global_position)
	# This is so annoying and I hate this

func can(ability: String) -> bool:
	match ability:
		"move":
			return can_move and not input_locked and abilities.unlocked("move")
		"jump":
			return can_jump and not input_locked and abilities.unlocked("jump")
		"dash":
			return can_dash and not input_locked and abilities.unlocked("dash")
		"gravity_switch":
			if state_machine.current_state is StateFloat:
				return not input_locked and abilities.unlocked("gravity_switch")
			else:
				return can_enter_nograv and not input_locked and abilities.unlocked("gravity_switch")
		"throw_wrench":
			return can_throw_wrench and not input_locked and abilities.unlocked("throw_wrench")
		_:
			return false

func unlock(ability: String) -> void:
	if not abilities.unlocked(ability):
		abilities.unlock(ability)
		ability_unlocked.emit(ability)

func lock(ability: String) -> void:
	if abilities.unlocked(ability):
		abilities.lock(ability)
		ability_locked.emit(ability)

func spawn_impact_cloud(pos: Vector2, rot: float) -> void:
	var cloud_instance = IMPACT_CLOUD.instantiate()
	cloud_instance.finished.connect(cloud_instance.queue_free)
	cloud_instance.finished.connect(_on_effect_finish.bind(cloud_instance))
	effects.add_child(cloud_instance)
	cloud_instance.global_position = pos
	cloud_instance.rotation_degrees = rot
	cloud_instance.emitting = true
	effect_nodes.append(cloud_instance)

func spawn_dash_cloud(pos: Vector2, rot: float) -> void:
	var cloud_instance = DASH_CLOUD.instantiate()
	cloud_instance.finished.connect(cloud_instance.queue_free)
	cloud_instance.finished.connect(_on_effect_finish.bind(cloud_instance))
	effects.add_child(cloud_instance)
	cloud_instance.global_position = pos
	cloud_instance.rotation_degrees = rot
	cloud_instance.emitting = true
	effect_nodes.append(cloud_instance)

func _on_effect_finish(node: Node2D) -> void:
	effect_nodes.erase(node)

func dash_effect(dir: Vector2) -> void:
	match dir:
		Vector2.UP:
			spawn_dash_cloud(global_position + Vector2.UP * get_half_height(), 0)
		Vector2.DOWN:
			spawn_dash_cloud(global_position + Vector2.DOWN * get_half_height(), 180)
		Vector2.LEFT:
			spawn_dash_cloud(global_position + Vector2.RIGHT * get_half_width(), 90)
		Vector2.RIGHT:
			spawn_dash_cloud(global_position + Vector2.LEFT * get_half_width(), -90)
	
	
