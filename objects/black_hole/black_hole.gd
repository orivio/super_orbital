class_name BlackHole extends Node2D

@export_range(0, 500) var mass: float = 100
@export var fixed: bool = false

var influencing_player: bool = false

func _enter_tree() -> void:
	PhysicsManager.black_holes.append(self)
	print("Added ", self)

func _exit_tree() -> void:
	PhysicsManager.black_holes.erase(self)
	print("Removed ", self)


func _on_influence_area_body_entered(body: Node2D) -> void:
	if body is Player:
		influencing_player = true

func _on_influence_area_body_exited(body: Node2D) -> void:
	if body is Player:
		influencing_player = false
