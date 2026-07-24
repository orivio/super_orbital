extends Node2D

@onready var world: World = $World

func _ready() -> void:
	world.init_room()
