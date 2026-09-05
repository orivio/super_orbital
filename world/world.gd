class_name World
extends Node2D

signal door_entered(direction: Types.DoorDirection)
signal reload_level_requested()

@onready var level_manager: LevelManager = $LevelManager


func _ready() -> void:
	level_manager.door_entered.connect(_on_door_entered)
	level_manager.reload_level_requested.connect(_on_reload_level_requested)


func initialize() -> void:
	await level_manager.initialize()


func do_level_transition(direction: Types.DoorDirection) -> void:
	await level_manager.do_level_transition(direction)


func goto_level(level_idx: int) -> void:
	await level_manager.goto_level(level_idx)


func reload_level() -> void:
	await level_manager.reload_level()


func _on_door_entered(direction: Types.DoorDirection) -> void:
	door_entered.emit(direction)


func _on_reload_level_requested() -> void:
	reload_level_requested.emit()
