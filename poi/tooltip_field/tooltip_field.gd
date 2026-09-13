class_name TooltipField
extends Area2D

@export var message: String
@export var unlocks_ability: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.unlock_ability(unlocks_ability)
	pass
