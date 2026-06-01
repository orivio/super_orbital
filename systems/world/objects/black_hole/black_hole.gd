class_name BlackHole extends Area2D

@export var mass: float = 10
@export var fixed: bool = false

func _enter_tree() -> void:
	PhysicsManager.black_holes.append(self)

func _exit_tree() -> void:
	PhysicsManager.black_holes.erase(self)
