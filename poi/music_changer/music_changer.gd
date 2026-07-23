extends Node

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if GameManager.current_room == null:
			pass
		match GameManager.current_room.scene_file_path.get_file():
			"room_move.tscn":
				AudioManager.stop_sound()
				AudioManager.change_music("res://music/2 martian_overture.ogg")
			_:
				pass
