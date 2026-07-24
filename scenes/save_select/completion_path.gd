class_name CompletionPath
extends Path2D


const PROGRESS_NODE: PackedScene = preload("res://ui/progress_node/progress_node.tscn")


@export var total_progress_node_count: int = 11


@onready var progress_bar: Line2D = $Line2D


var displayed: bool = false
var progress_nodes: Array[ProgressNode]


func _ready() -> void:
	progress_bar.points = curve.get_baked_points()

func add_progress_node(completion_percentage: float, text: StringName) -> void:
	var progress_node_instance: ProgressNode = PROGRESS_NODE.instantiate()
	progress_node_instance.completion_percentage = completion_percentage
	progress_node_instance.text = text
	add_child(progress_node_instance)
	progress_nodes.append(progress_node_instance)


func display_completion_path(save_file: SaveFile) -> void:
	var i: int = 0 # A trick for percentages, make the counter go up by 100s
	for progress_name in save_file.progress_data:
		add_progress_node((i + 0.0) / total_progress_node_count, progress_name)
		i += 100
	displayed = true

func wipe_completion_path() -> void:
	for child in progress_nodes:
		child.queue_free()
	progress_nodes.clear()
	displayed = false
