class_name WaitMessage
extends Area2D

@export var time: float
@export var text: String

@onready var wait_timer: Timer = $WaitTimer


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		wait_timer.start(time)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		wait_timer.stop()
		body.hide_tooltip()


func _on_wait_timer_timeout() -> void:
	var calculated_text: String = DialogueSystem.get_formatted_text(text)
	GameManager.player.show_tooltip(calculated_text)
