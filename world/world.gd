class_name World
extends Node2D

signal room_transition(dest_room: String, dest_door_tag: String)

@onready var room_manager: RoomManager = $RoomManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_manager.transition_entered.connect(_on_transition_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func init_room() -> void:
	room_manager.load_initial_room()


func do_room_transition(dest_room: String, dest_door_tag: String) -> void:
	await room_manager.change_room(dest_room, dest_door_tag, true)


func _on_transition_entered(dest_room: String, dest_door_tag: String) -> void:
	room_transition.emit(dest_room, dest_door_tag)
