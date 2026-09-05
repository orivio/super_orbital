@tool
class_name Player
extends CharacterBody2D

signal player_death
signal ability_unlocked(name: String)
signal ability_locked(name: String)

# Not the same as the Statemachine, which is for physics and movement. This is 
# for top level state that determines how the Player is updated each frame.
enum PlayerState {
	UNINITIALIZED,
	GAMEPLAY,
	DISABLED,
	DYING,
}
# Used for the shader parameter.
enum GravityState {
	BLACK_HOLE = 0,
	FLOAT = 1,
	NORMAL = 2,
}

const IMPACT_CLOUD = preload("res://effects/impact_cloud/impact_cloud.tscn")
const DUST_CLOUD = preload("res://effects/dust_cloud/dust_cloud.tscn")
const DASH_CLOUD = preload("res://effects/dash_cloud/dash_cloud.tscn")
const AFTER_IMAGE = preload("res://effects/player_afterimage/player_afterimage.tscn")
const WRENCH_PROJECTILE = preload("uid://cgbxshe71m18w")


@export_category("Movement and Abilities")
@export var movement_settings: PlayerMovementSettings
@export var abilities: PlayerAbilities = null
@export_category("Death Sequence Settings")
@export_range(0.0, 1.0) var death_time: float
@export_range(0.0, 0.3) var death_hitstop_time: float
@export_range(0.0, 15.0) var death_camera_shake_strength: float
@export_category("Afterimage Settings")
@export_range(0.0, 1.0) var afterimage_period: float
@export_range(0.0, 2.0) var afterimage_fade_time: float

# Components
@onready var state_machine: StateMachine = $StateMachine
@onready var input: InputComponent = $InputComponent
@onready var debug_overlay: DebugOverlay = $DebugOverlay
# Visuals
@onready var sprite: Sprite2D = $VisualComponents/Sprite2D
@onready var animation_player: AnimationPlayer = $VisualComponents/AnimationPlayer
@onready var shockwave_controller: AnimationPlayer = $VisualComponents/ShockwaveController
@onready var animation_tree: AnimationTree = $VisualComponents/AnimationTree
@onready var tooltip: Tooltip = $VisualComponents/Tooltip
# Timers
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var dash_buffer_timer: Timer = $Timers/DashBufferTimer
@onready var grav_switch_buffer_timer: Timer = $Timers/GravSwitchBufferTimer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var afterimage_timer: Timer = $Timers/AfterImageTimer
@onready var dash_exit_timer: Timer = $Timers/DashExitTimer
# Physics components
@onready var floorcaster: ShapeCast2D = $Raycasts/Floorcaster
@onready var left_ceiling_raycast: RayCast2D = $Raycasts/LCeilingRaycast
@onready var middle_ceiling_raycast: RayCast2D = $Raycasts/MCeilingRaycast
@onready var right_ceiling_raycast: RayCast2D = $Raycasts/RCeilingRaycast
@onready var upper_right_wallcaster: RayCast2D = $Raycasts/UpperRightWallcaster
@onready var upper_middle_right_wallcaster: RayCast2D = $Raycasts/UpperMiddleRightWallcaster
@onready var lower_middle_right_wallcaster: RayCast2D = $Raycasts/LowerMiddleRightWallcaster
@onready var lower_right_wallcaster: RayCast2D = $Raycasts/LowerRightWallcaster
@onready var upper_left_wallcaster: RayCast2D = $Raycasts/UpperLeftWallcaster
@onready var upper_middle_left_wallcaster: RayCast2D = $Raycasts/UpperMiddleLeftWallcaster
@onready var lower_middle_left_wallcaster: RayCast2D = $Raycasts/LowerMiddleLeftWallcaster
@onready var lower_left_wallcaster: RayCast2D = $Raycasts/LowerLeftWallcaster
@onready var collider: CollisionShape2D = $CollisionShape2D


# Visual logic
var facing_right: bool = true
var anim_playback: AnimationNodeStateMachinePlayback
# Movement logic
var was_on_floor_last_frame: bool
var jump_buffer: bool
var dash_velocity_buffer: Vector2
var dash_buffer: bool
var grav_switch_buffer: bool
var coyote_buffer: bool
var has_dash: bool
var dash_on_cooldown: bool
# State management
var frames_passed: int
var current_player_state: PlayerState
var input_locked: bool


func _ready() -> void:
	if not Engine.is_editor_hint():
		# Set up player state
		current_player_state = PlayerState.UNINITIALIZED
		# Set up the animation tree
		anim_playback = animation_tree.get("parameters/playback")
		# Set up global references
		GameManager.player = self
		# Connect signals
		ability_unlocked.connect(SaveManager._on_ability_unlocked)
		ability_locked.connect(SaveManager._on_ability_locked)
		# Ready the state machine
		state_machine.initialize()
	else:
		movement_settings.debug_visual_changed.connect(_on_debug_visual_changed)


#region Main Loops
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		match current_player_state:
			PlayerState.GAMEPLAY:
				state_machine.process(delta)
		
		# Visual logic
		if facing_right:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		
		#region Tooltip Update
		if state_machine.current_state is IdleState:
			tooltip.show_tooltip("Idle")
			sprite.material.set_shader_parameter("gravity_state", GravityState.NORMAL)
		elif state_machine.current_state is WalkState:
			tooltip.show_tooltip("Walk")
			sprite.material.set_shader_parameter("gravity_state", GravityState.NORMAL)
		elif state_machine.current_state is JumpState:
			tooltip.show_tooltip("Jump")
			sprite.material.set_shader_parameter("gravity_state", GravityState.NORMAL)
		elif state_machine.current_state is FallState:
			tooltip.show_tooltip("Fall")
			sprite.material.set_shader_parameter("gravity_state", GravityState.NORMAL)
		elif state_machine.current_state is DashState:
			tooltip.show_tooltip("Dash")
			sprite.material.set_shader_parameter("gravity_state", GravityState.NORMAL)
		elif state_machine.current_state is FloatState:
			tooltip.show_tooltip("Float")
			sprite.material.set_shader_parameter("gravity_state", GravityState.FLOAT)
		else:
			tooltip.hide_tooltip()
		
		if false:
			tooltip.show_tooltip(str(frames_passed))
		if true:
			tooltip.show_tooltip(str(velocity.y))
		#endregion


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if delta != 0:
			frames_passed += 1
			if velocity.x > 0:
				facing_right = true
			elif velocity.x < 0:
				facing_right = false
		
		#region Physics Loop
		
		match current_player_state:
			PlayerState.GAMEPLAY:
				input.physics_process(delta)
				
				# Update movement logic
				if input.jump_pressed:
					jump_buffer = true
					jump_buffer_timer.start(movement_settings.jump_buffer_time)
				
				if input.dash_pressed:
					dash_buffer = true
					dash_velocity_buffer = resolve_dash_velocity()
					dash_buffer_timer.start(movement_settings.dash_buffer_time)
				
				if input.grav_switch_pressed:
					grav_switch_buffer = true
					grav_switch_buffer_timer.start(movement_settings.grav_switch_buffer_time)
				
				if floorcaster.is_colliding():
					was_on_floor_last_frame = true
					coyote_buffer = true
					has_dash = true
				else:
					if was_on_floor_last_frame:
						was_on_floor_last_frame = false
						coyote_buffer = true
						coyote_timer.start(movement_settings.coyote_time)
				
				if delta != 0:
					state_machine.physics_process(delta)
		#endregion
#endregion


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


#region Player API
func initialize() -> void:
	load_abilities()
	current_player_state = PlayerState.GAMEPLAY
	dash_on_cooldown = false


func reset() -> void:
	velocity = Vector2.ZERO
	was_on_floor_last_frame = false
	jump_buffer = false
	dash_buffer = false
	grav_switch_buffer = false
	coyote_buffer = true
	has_dash = true
	dash_on_cooldown = false
	state_machine.reset()
	current_player_state = PlayerState.GAMEPLAY
	anim_playback.travel("idle")
	set_process_mode(Node.PROCESS_MODE_INHERIT)


func load_abilities() -> void:
	if not abilities:
		abilities = SaveManager.get_save_file().player_abilities


func die() -> void:
	current_player_state = PlayerState.DYING
	GameManager.hitstop(death_hitstop_time)
	GameManager.camera_shake(death_camera_shake_strength)
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


func do_shockwave() -> void:
	shockwave_controller.play(&"shockwave")


func get_half_height() -> float:
	return collider.shape.get_rect().size.y / 2


func get_half_width() -> float:
	return collider.shape.get_rect().size.x / 2 + 10


func get_center_of_mass() -> Vector2:
	return Vector2(0, -25)


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


func start_afterimage_effect() -> void:
	spawn_afterimage()
	afterimage_timer.start(afterimage_period)


func stop_afterimage_effect() -> void:
	afterimage_timer.stop()


func spawn_afterimage() -> void:
	var afterimage: PlayerAfterimage = AFTER_IMAGE.instantiate()
	afterimage.frame = sprite.frame
	afterimage.fade_time = afterimage_fade_time
	afterimage.sprite_flip_h = sprite.flip_h
	afterimage.global_position = global_position
	GameManager.current_level.add_effect(afterimage)


func exit_dash_to_fall() -> void:
	anim_playback.travel("dash_exit")
	dash_exit_timer.start(0.0667)


func spawn_wrench_projectile(throw_velocity: Vector2) -> void:
	var wrench_projectile: WrenchProjectile = WRENCH_PROJECTILE.instantiate()
	wrench_projectile.velocity = -throw_velocity * movement_settings.wrench_throw_velocity_multiplier
	wrench_projectile.rotation_speed = 6
	wrench_projectile.global_position = global_position + get_center_of_mass()
	GameManager.current_level.add_object(wrench_projectile)
	GameManager.hitstop(movement_settings.throw_wrench_hitstop)


#endregion


#region Physics Logic
func can_jump() -> bool:
	return jump_buffer and coyote_buffer


func do_jump() -> void:
	jump_buffer = false
	coyote_buffer = false
	velocity.y = -movement_settings.jump_initial_velocity
	ceiling_clip_nudge()


func can_dash() -> bool:
	# TODO: Dash buffering?
	return has_dash and dash_buffer and not dash_on_cooldown


func do_dash() -> void:
	GameManager.hitstop(movement_settings.dash_hitstop)
	dash_buffer = false
	has_dash = false
	dash_on_cooldown = true
	dash_cooldown_timer.start(movement_settings.dash_cooldown)
	
	assert(dash_velocity_buffer != Vector2.ZERO)
	
	GameManager.camera_shake_directional(dash_velocity_buffer.normalized(), movement_settings.dash_camera_shake_strength)
	wall_clip_nudge()
	velocity = dash_velocity_buffer
	dash_velocity_buffer = Vector2.ZERO


func can_grav_switch() -> bool:
	return grav_switch_buffer


func do_grav_switch() -> void:
	grav_switch_buffer = false
	GameManager.hitstop(movement_settings.grav_off_hitstop)
	GameManager.camera_shake(movement_settings.grav_switch_camera_shake_strength)
	do_shockwave()


func turn_on_gravity() -> void:
	grav_switch_buffer = false
	GameManager.hitstop(movement_settings.grav_on_hitstop)
	GameManager.camera_shake(movement_settings.grav_switch_camera_shake_strength)


func can_throw_wrench() -> bool:
	return input.throw_wrench_pressed and not input.direction == Vector2.ZERO


func do_throw_wrench() -> void:
	var wrench_velocity: Vector2 = -input.direction
	velocity = wrench_velocity * velocity.length()
	spawn_wrench_projectile(velocity)


func resolve_dash_velocity() -> Vector2:
	var dash_velocity: Vector2
	var dash_direction: Vector2
	if not movement_settings.allow_orthognal_dash:
		dash_direction = input.cardinal_direction
		if dash_direction == Vector2.ZERO:
			dash_direction = Vector2(1 if facing_right else -1, 0)
		dash_velocity = dash_direction * movement_settings.dash_velocity
		if dash_direction == Vector2.UP:
			dash_velocity *= movement_settings.upward_dash_scale
	else:
		dash_direction = input.direction
		if dash_direction.length_squared() < movement_settings.minimum_movement_threshold * movement_settings.minimum_movement_threshold:
			dash_direction = Vector2(1 if facing_right else -1, 0)
		else:
			dash_direction = dash_direction.normalized() * 1
		dash_velocity = dash_direction * movement_settings.dash_velocity
		if dash_direction == Vector2.UP:
			dash_velocity *= movement_settings.upward_dash_scale
		elif abs(dash_direction.x) > movement_settings.minimum_movement_threshold and dash_direction.y < 0:
			dash_velocity *= movement_settings.orthogonal_dash_scale
	return dash_velocity

func ceiling_clip_nudge() -> void:
	# Not sure if this is the best way to do it, it does feel a little bit buggy
	#if middle_ceiling_raycast.is_colliding():
	if velocity.y < -movement_settings.ceiling_clip_min_velocity:
		if left_ceiling_raycast.is_colliding() and not right_ceiling_raycast.is_colliding():
			global_position.x = right_ceiling_raycast.global_position.x
		if right_ceiling_raycast.is_colliding() and not left_ceiling_raycast.is_colliding():
			global_position.x = left_ceiling_raycast.global_position.x


func wall_clip_nudge() -> void:
	if abs(velocity.x) > movement_settings.wall_clip_min_velocity:
		if velocity.x > 0:
			if upper_right_wallcaster.is_colliding() and not upper_middle_right_wallcaster.is_colliding():
				position.y += upper_middle_right_wallcaster.position.y - upper_right_wallcaster.position.y
			if lower_right_wallcaster.is_colliding() and not lower_middle_right_wallcaster.is_colliding():
				position.y += lower_middle_right_wallcaster.position.y - lower_right_wallcaster.position.y
		else:
			if upper_left_wallcaster.is_colliding() and not upper_middle_left_wallcaster.is_colliding():
				position.y += upper_middle_left_wallcaster.position.y - upper_left_wallcaster.position.y
			if lower_left_wallcaster.is_colliding() and not lower_middle_left_wallcaster.is_colliding():
				position.y += lower_middle_left_wallcaster.position.y - lower_left_wallcaster.position.y
#endregion


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


func _on_dash_buffer_timeout() -> void:
	dash_buffer = false


func _on_grav_switch_buffer_timeout() -> void:
	grav_switch_buffer = false


func _on_coyote_timeout() -> void:
	coyote_buffer = false


func _on_dash_cooldown_timeout() -> void:
	dash_on_cooldown = false


func _on_dash_exit_timeout() -> void:
	anim_playback.travel("jump")


func _on_after_image_timeout() -> void:
	spawn_afterimage()


func _on_debug_visual_changed() -> void:
	debug_overlay.queue_redraw()
