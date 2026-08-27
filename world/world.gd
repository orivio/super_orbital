class_name World
extends Node2D

signal door_entered(direction: Types.DoorDirection)

@onready var level_manager: LevelManager = $LevelManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_manager.door_entered.connect(_on_door_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func initialize() -> void:
	level_manager.initialize()


func do_level_transition(direction: Types.DoorDirection) -> void:
	await level_manager.do_level_transition(direction)


func _on_door_entered(direction: Types.DoorDirection) -> void:
	door_entered.emit(direction)
