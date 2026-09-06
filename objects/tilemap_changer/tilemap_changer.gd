class_name TileMapChanger
extends Node2D

@export var pattern: TileMapPattern
@export var destination: Vector2

@onready var target: TileMapLayer = $"../../TileMapLayer"


func change() -> void:
	target.set_pattern(destination, pattern)
