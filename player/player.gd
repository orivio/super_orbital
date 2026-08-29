class_name Player
extends CharacterBody2D

signal player_death
signal ability_unlocked(name: String)
signal ability_locked(name: String)

const IMPACT_CLOUD = preload("res://effects/impact_cloud/impact_cloud.tscn")
const DUST_CLOUD = preload("res://effects/dust_cloud/dust_cloud.tscn")
const DASH_CLOUD = preload("res://effects/dash_cloud/dash_cloud.tscn")
const AFTER_IMAGE = preload("res://effects/player_afterimage/player_afterimage.tscn")

@export var movement_settings: PlayerMovementSettings
@export var abilities: PlayerAbilities = null

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var tooltip: Label = $Tooltip
@onready var input: InputComponent = $InputComponent
@onready var floor_raycast: RayCast2D = $FloorRaycast

var facing_right: bool = true


func _ready() -> void:
	GameManager.player = self
	ability_unlocked.connect(SaveManager._on_ability_unlocked)
	ability_locked.connect(SaveManager._on_ability_locked)
	state_machine.initialize()


func _process(delta: float) -> void:
	state_machine.process(delta)
	if facing_right:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	state_machine.physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.input(event)


func initialize() -> void:
	load_abilities()


func reset() -> void:
	velocity = Vector2.ZERO
	state_machine.reset()


func load_abilities() -> void:
	if not abilities:
		abilities = SaveManager.get_save_file().player_abilities

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
