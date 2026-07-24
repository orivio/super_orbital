@tool
class_name ProgressNode
extends PathFollow2D


@export_range(0.0, 100.0) var completion_percentage: float = 0
@export var text: StringName


@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_ratio = completion_percentage / 100.0
	label.text = text
