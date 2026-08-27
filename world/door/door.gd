@tool
class_name Door
extends Area2D

signal door_entered(direction: Types.DoorDirection)

@export var door_tag: String
@export var dest_door: String
@export var dest_room: String
@export var direction: Types.DoorDirection = Types.DoorDirection.EAST

@onready var spawn: Marker2D = $Spawn


func get_spawn_pos() -> Vector2:
	return spawn.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Emit a signal which will bubble up to the play scene to manage room
		# transition
		door_entered.emit(direction)
