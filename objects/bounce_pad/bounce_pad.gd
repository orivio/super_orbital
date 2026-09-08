class_name BouncePad
extends Area2D

@export var velocity: Vector2


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity += velocity
		body.has_dash = true
