class_name Player extends CharacterBody2D

signal player_death

@export var movement_settings: PlayerMovementSettings

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

func _ready() -> void:
	GameManager.player = self
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

func update_animation(animation: String) -> void:
	if animation_player.current_animation != animation:
		animation_player.play(animation)

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
