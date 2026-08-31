extends TabContainer

signal controls_changed
signal audio_changed
signal graphics_changed


func _on_controls_controls_changed() -> void:
	controls_changed.emit()


func _on_audio_audio_changed() -> void:
	audio_changed.emit()


func _on_graphics_graphics_changed() -> void:
	graphics_changed.emit()
