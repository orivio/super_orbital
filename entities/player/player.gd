class_name Player extends CharacterBody2D

@export var movement_settings: PlayerMovementSettings

var direction: float:
	set(value):
		direction = value
		if value != 0:
			facing = value
var facing: float
var has_gravity: bool
var can_dash: bool

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tooltip: Tooltip = $Tooltip

func _ready() -> void:
	GameManager.player = self
	state_machine.initialize()

func _process(_delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right") * game_manager.time_scale

func _physics_process(_delta: float) -> void:
	#print(state_machine.current_state)
	if is_on_floor():
		can_dash = true
	else:
		if has_gravity:
			if velocity.y < 0:
				velocity.y += movement_settings.gravity * game_manager.time_scale
			else:
				velocity.y += movement_settings.gravity * movement_settings.downward_gravity_multiplier * game_manager.time_scale
	
	move_and_slide()

func update_animation(animation: String) -> void:
	if animation_player.current_animation != animation:
		animation_player.play(animation)

func show_tooltip(message: String) -> void:
	tooltip.show_tooltip(message)

func hide_tooltip() -> void:
	tooltip.hide_tooltip()
