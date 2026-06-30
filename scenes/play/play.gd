extends Node2D

@onready var world: World = $World

func _ready() -> void:
	SaveManager.load_save_file()
	world.init_room()
