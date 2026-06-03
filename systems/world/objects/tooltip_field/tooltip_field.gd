class_name TooltipField extends Area2D

@export var message: String



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and "show_tooltip" in body:
		body.show_tooltip(message)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and "hide_tooltip" in body:
		body.hide_tooltip()
