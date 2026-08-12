class_name LevelGrid
extends Control


const LEVEL_MARKER: PackedScene = preload("res://ui/level_marker/level_marker.tscn")


@onready var grid_container: GridContainer = $HBoxContainer/Grid
@onready var left_button: Button = $HBoxContainer/LeftButton
@onready var right_button: Button = $HBoxContainer/RightButton


func update_visuals(save_file: SaveFile) -> void:
	for node in grid_container.get_children():
		node.queue_free()
	
	var count: int = 1
	
	for level_name in GameManager.rooms:
		var level_marker_instance: Control = LEVEL_MARKER.instantiate()
		grid_container.add_child(level_marker_instance)
		level_marker_instance.get_node("Label").text = level_name
		count += 1
		if count > 15:
			break
