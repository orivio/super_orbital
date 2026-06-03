class_name Door extends Area2D

signal door_entered(dest_room_path: String, dest_door_tag: String)

@export var door_tag: String
@export var dest_door_tag: String
@export_file("*.tscn") var dest_room_path: String

@onready var spawn: Marker2D = $Spawn

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		door_entered.emit(dest_room_path, dest_door_tag)
