class_name World
extends Node2D

signal door_entered(direction: Types.DoorDirection)

@onready var room_manager: RoomManager = $RoomManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_manager.door_entered.connect(_on_door_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func initialize() -> void:
	room_manager.initialize()


func do_room_transition(direction: Types.DoorDirection) -> void:
	await room_manager.do_room_transition(direction)


func _on_door_entered(direction: Types.DoorDirection) -> void:
	door_entered.emit(direction)
