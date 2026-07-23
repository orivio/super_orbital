extends Node

@export_file(".ogg") var music: String;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if music != "":
			AudioManager.stop_sound()
			AudioManager.change_music(music)
