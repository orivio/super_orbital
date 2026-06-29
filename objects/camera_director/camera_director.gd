extends Area2D

@export var camera_zoom: float = 1
@export var in_time: float = 0.8
@export var stay_time: float = 0
@export var out_time: float = 0.8
@export var blocks_player: bool = false

func get_zoom() -> float:
	return camera_zoom


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.camera.direct(camera_zoom, in_time, stay_time, out_time, blocks_player)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		GameManager.camera.undirect()
