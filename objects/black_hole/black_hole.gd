class_name BlackHole
extends Node2D

@export_range(0, 500) var mass: float = 100
@export var fixed: bool = false


func _on_influence_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enter_blackhole(self)

func _on_influence_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.exit_blackhole(self)
