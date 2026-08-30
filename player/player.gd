class_name Player
extends CharacterBody2D

signal player_death
signal ability_unlocked(name: String)
signal ability_locked(name: String)

enum PlayerState {
	UNINITIALIZED,
	GAMEPLAY,
	DISABLED,
	DYING,
}

const IMPACT_CLOUD = preload("res://effects/impact_cloud/impact_cloud.tscn")
const DUST_CLOUD = preload("res://effects/dust_cloud/dust_cloud.tscn")
const DASH_CLOUD = preload("res://effects/dash_cloud/dash_cloud.tscn")
const AFTER_IMAGE = preload("res://effects/player_afterimage/player_afterimage.tscn")

@export var movement_settings: PlayerMovementSettings
@export var abilities: PlayerAbilities = null
@export var death_time: float

# Components
@onready var state_machine: StateMachine = $StateMachine
@onready var input: InputComponent = $InputComponent
# Child nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var tooltip: Tooltip = $Tooltip
# Timers
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var death_timer: Timer = $DeathTimer
# Raycasts
@onready var floorcaster: ShapeCast2D = $Floorcaster
@onready var left_ceiling_raycast: RayCast2D = $LCeilingRaycast
@onready var middle_ceiling_raycast: RayCast2D = $MCeilingRaycast
@onready var right_ceiling_raycast: RayCast2D = $RCeilingRaycast


var facing_right: bool = true
var was_on_floor_last_frame: bool
var jump_buffer: bool
var coyote_buffer: bool
var frames_passed: int
var current_player_state: PlayerState
var input_locked: bool


func _ready() -> void:
	current_player_state = PlayerState.UNINITIALIZED
	GameManager.player = self
	ability_unlocked.connect(SaveManager._on_ability_unlocked)
	ability_locked.connect(SaveManager._on_ability_locked)
	state_machine.initialize()


func _process(delta: float) -> void:
	match current_player_state:
		PlayerState.GAMEPLAY:
			state_machine.process(delta)
	
	if facing_right:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	if state_machine.current_state is IdleState:
		tooltip.show_tooltip("Idle")
	elif state_machine.current_state is WalkState:
		tooltip.show_tooltip("Walk")
	elif state_machine.current_state is JumpState:
		tooltip.show_tooltip("Jump")
	elif state_machine.current_state is FallState:
		tooltip.show_tooltip("Fall")
	else:
		tooltip.hide_tooltip()
	
	if false:
		tooltip.show_tooltip(str(frames_passed))


func _physics_process(delta: float) -> void:
	frames_passed += 1
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	
	match current_player_state:
		PlayerState.GAMEPLAY:
			input.physics_process(delta)
			
			if input.jump_pressed:
				jump_buffer = true
				jump_buffer_timer.start(movement_settings.jump_buffer_time)
			
			if floorcaster.is_colliding():
				was_on_floor_last_frame = true
				coyote_buffer = true
			else:
				if was_on_floor_last_frame:
					was_on_floor_last_frame = false
					coyote_buffer = true
					coyote_timer.start(movement_settings.coyote_time)
			
			state_machine.physics_process(delta)
			print(velocity.y)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func initialize() -> void:
	load_abilities()
	current_player_state = PlayerState.GAMEPLAY


func reset() -> void:
	velocity = Vector2.ZERO
	state_machine.reset()
	current_player_state = PlayerState.GAMEPLAY
	set_process_mode(Node.PROCESS_MODE_INHERIT)


func load_abilities() -> void:
	if not abilities:
		abilities = SaveManager.get_save_file().player_abilities


func die() -> void:
	current_player_state = PlayerState.DYING
	death_timer.start(death_time)
	await death_timer.timeout
	player_death.emit()


func disable() -> void:
	current_player_state = PlayerState.DISABLED
	set_process_mode(Node.PROCESS_MODE_DISABLED)


func enable() -> void:
	current_player_state = PlayerState.GAMEPLAY
	set_process_mode(Node.PROCESS_MODE_INHERIT)


func lock_input() -> void:
	input_locked = true


func unlock_input() -> void:
	input_locked = false


func show_tooltip(message: String) -> void:
	tooltip.show_tooltip(message)


func hide_tooltip() -> void:
	tooltip.hide_tooltip()


func get_half_height() -> float:
	return collider.shape.get_rect().size.y / 2


func get_half_width() -> float:
	return collider.shape.get_rect().size.x / 2 + 10


func teleport_to_ground(target: Vector2) -> void:
	global_position = target


func unlock_ability(ability: String) -> void:
	if not abilities.unlocked(ability):
		abilities.unlock(ability)
		ability_unlocked.emit(ability)


func lock_ability(ability: String) -> void:
	if abilities.unlocked(ability):
		abilities.lock(ability)
		ability_locked.emit(ability)


func can_jump() -> bool:
	return jump_buffer and coyote_buffer


func do_jump() -> void:
	jump_buffer = false
	coyote_buffer = false
	velocity.y = -movement_settings.jump_initial_velocity
	ceiling_clip_nudge()


func ceiling_clip_nudge() -> void:
	#if middle_ceiling_raycast.is_colliding():
	if left_ceiling_raycast.is_colliding() and not right_ceiling_raycast.is_colliding():
		global_position.x = right_ceiling_raycast.global_position.x
	if right_ceiling_raycast.is_colliding() and not left_ceiling_raycast.is_colliding():
		global_position.x = left_ceiling_raycast.global_position.x

func take_hit() -> void:
	match current_player_state:
		PlayerState.GAMEPLAY:
			die()
		PlayerState.UNINITIALIZED:
			return
		PlayerState.DISABLED:
			return
		PlayerState.DYING:
			return

func _on_jump_buffer_timeout() -> void:
	jump_buffer = false


func _on_coyote_timeout() -> void:
	coyote_buffer = false
