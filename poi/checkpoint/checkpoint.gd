class_name Checkpoint
extends Area2D

signal player_entered(idx: int)

@onready var marker_2d: Marker2D = $Marker2D

var idx: int


func initialize(number: int) -> void:
	idx = number


func get_spawn_pos() -> Vector2:
	return marker_2d.global_position


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit(idx)
