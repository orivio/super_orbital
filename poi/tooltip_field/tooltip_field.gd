class_name TooltipField
extends Area2D

@export var message: String
@export var unlocks_ability: String


func _on_body_entered(_body: Node2D) -> void:
	#if body.is_in_group("player") and "show_tooltip" in body and not body.disabled and not body.tooltips_disabled:
	#	body.show_tooltip(message)
	#	body.unlock(unlocks_ability)
	#	#print("Showing tooltip: ", message)
	pass


func _on_body_exited(_body: Node2D) -> void:
	#if body.is_in_group("player") and "hide_tooltip" in body and not body.disabled:
	#	body.hide_tooltip()
	#	#print("Hiding tooltip: ", message)
	pass
