class_name CutsceneActivator
extends Area2D

@export var cutscene: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		await GameManager.play.start_cutscene(cutscene)
