class_name WrenchItem extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		wrench_get(body)

func wrench_get(player: Node2D):
	player.can_throw_wrench = true
	queue_free()
