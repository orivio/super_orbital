class_name Tooltip extends Label

func _ready() -> void:
	visible = false

func show_tooltip(message: String) -> void:
	# Maybe keep the tooltips
	visible = false
	text = message

func hide_tooltip() -> void:
	visible = false
