class_name HurtBox
extends Area2D

@onready var player: Player = $".."


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer or body is AnimatableBody2D:
		player.take_hit()
		player.play_spike_death_sound()


func _on_area_entered(_area: Area2D) -> void:
	player.take_hit()
	player.play_black_hole_death_sound()
