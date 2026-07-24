class_name ProgressDetector
extends Area2D


@export var progress_name: StringName

var completed: bool

func load_data_from_savefile(save_file: SaveFile) -> void:
	completed = save_file.progress_data.has(progress_name)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not completed:
		print("Hello!")
		GameManager.attain_progress(progress_name)
