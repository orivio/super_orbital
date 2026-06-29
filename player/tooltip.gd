class_name Tooltip extends Label

func _ready() -> void:
	visible = false

func show_tooltip(message: String) -> void:
	visible = true
	text = message

func hide_tooltip() -> void:
	visible = false
