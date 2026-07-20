class_name World
extends Node2D

@onready var room_manager: RoomManager = $RoomManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func init_room() -> void:
	room_manager.load_initial_room()
