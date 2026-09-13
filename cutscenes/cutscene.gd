class_name Cutscene
extends Control

signal cutscene_finished

@export var animation_name: StringName

@onready var cutscene_director: AnimationPlayer = $CutsceneDirector


func start() -> void:
	cutscene_director.play(animation_name)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cutscene_director.stop()
		cutscene_finished.emit()


func _on_cutscene_director_animation_finished(_anim_name: StringName) -> void:
	cutscene_finished.emit()
