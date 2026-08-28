class_name BlackHole
extends Node2D

@export_range(0, 500) var mass: float = 100
@export var fixed: bool = false

var influencing_player: bool = false


func _enter_tree() -> void:
	PhysicsManager.black_holes.append(self)


func _exit_tree() -> void:
	PhysicsManager.black_holes.erase(self)


func _on_influence_area_body_entered(_body: Node2D) -> void:
	pass

func _on_influence_area_body_exited(_body: Node2D) -> void:
	pass
