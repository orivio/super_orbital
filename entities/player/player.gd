class_name Player extends CharacterBody2D

@export var player_movement_settings: PlayerMovementSettings

var direction: float
var has_gravity: bool
var can_dash: bool

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GameManager.player = self
	state_machine.player_movement_settings = player_movement_settings
	state_machine.initialize()

func _process(_delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		can_dash = true
	else:
		if has_gravity:
			if velocity.y < 0:
				velocity.y += player_movement_settings.gravity
			else:
				velocity.y += player_movement_settings.gravity * player_movement_settings.downward_gravity_multiplier
	
	move_and_slide()

func update_animation(animation: String):
	if animation_player.current_animation != animation:
		animation_player.play(animation)
