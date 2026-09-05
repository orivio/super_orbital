class_name HurtBox
extends Area2D

@onready var player: Player = $".."


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		player.take_hit()
	pass


func _on_area_entered(_area: Area2D) -> void:
	#if area.is_in_group("black_hole") and not player.disabled:
	#	player.die()
	pass
