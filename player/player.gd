class_name Player
extends CharacterBody2D

signal player_death
signal ability_unlocked(name: String)
signal ability_locked(name: String)

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
var can_gravity_switch: bool = true
var can_jump: bool = true
var can_throw_wrench: bool = true
var input_locked: bool
var death_timer: float = 0
var disabled: bool = false
var tooltips_disabled: bool = false
var jump_buffer: bool = false

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tooltip: Tooltip = $Tooltip
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var floor_caster: ShapeCast2D = $FloorCaster

func _ready() -> void:
	GameManager.player = self
	ability_unlocked.connect(SaveManager._on_ability_unlocked)
	ability_locked.connect(SaveManager._on_ability_locked)
	state_machine.initialize()

func _process(delta: float) -> void:
	if !input_locked:
		direction = Input.get_axis("move_left", "move_right")
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
			can_gravity_switch = true
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
	

func _physics_process(_delta: float) -> void:
	#print(state_machine.current_state)
	if is_on_floor() and !input_locked:
		can_dash = true
	else:
		if has_gravity:
			if base_velocity.y < 0:
				base_velocity.y += movement_settings.gravity * GameManager.time_scale
			else:
				base_velocity.y += movement_settings.gravity * movement_settings.downward_gravity_multiplier * GameManager.time_scale

	velocity = base_velocity * GameManager.time_scale

	move_and_slide()

func load_abilities() -> void:
	if not abilities:
		abilities = SaveManager.get_save_file().player_abilities

func update_animation(animation: String) -> void:
	if animation_player.current_animation != animation:
		animation_player.play(animation)

func show_tooltip(message: String) -> void:
	tooltip.show_tooltip(message)

func hide_tooltip() -> void:
	tooltip.hide_tooltip()

func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
	#	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
	#		teleport_to_ground(get_global_mouse_position())
	pass

func die() -> void:
	has_gravity = true
	is_dying = true
	can_dash = false
	can_move = false
	can_jump = false
	can_throw_wrench = false
	can_gravity_switch = false
	input_locked = true
	update_animation("hit")
	GameManager.impact()
	death_timer = 0.4
	tooltips_disabled = true

func on_jump_buffer_timeout() -> void:
	jump_buffer = false

func get_half_height() -> float:
	return collider.shape.get_rect().size.y / 2

func _on_death_timeout() -> void:
	tooltips_disabled = false

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
			return can_gravity_switch and not input_locked and abilities.unlocked("gravity_switch")
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
