class_name Cutscene
extends Node2D

signal cutscene_finished

@export var animation_name: StringName

@onready var cutscene_director: AnimationPlayer = $CutsceneDirector


func start() -> void:
	cutscene_director.play(animation_name)


func _on_cutscene_director_animation_finished(_anim_name: StringName) -> void:
	cutscene_finished.emit()
