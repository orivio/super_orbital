class_name BlackHole extends Node2D

@export_range(0, 500) var mass: float = 100
@export var fixed: bool = false

var influencing_player: bool = false

func _enter_tree() -> void:
	PhysicsManager.black_holes.append(self)

func _exit_tree() -> void:
	PhysicsManager.black_holes.erase(self)


func _on_influence_area_body_entered(body: Node2D) -> void:
	if body is Player and not body.disabled:
		influencing_player = true
		body.in_blackhole = true
		if not body.state_machine.current_state is StateFloat:
			GameManager.time_scale = 0.5
			body.state_machine.change_state(body.get_node("StateMachine/BlackHole"))

func _on_influence_area_body_exited(body: Node2D) -> void:
	if body is Player and not body.disabled:
		influencing_player = false
		body.in_blackhole = false
		GameManager.time_scale = 1
		GameManager.player_left_blackhole.emit()
