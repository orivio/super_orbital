@tool
class_name Level
extends Node2D

signal door_entered(direction: Types.DoorDirection)

@onready var camera_bounds: CollisionShape2D = $CameraBounds/CollisionShape2D
@onready var doors: Node2D = $Doors
@onready var objects: Node2D = $Objects
@onready var effects: Node2D = $Effects
@onready var color_rect: ColorRect = $Background/ColorRect


func _ready() -> void:
	if not Engine.is_editor_hint():
		# Attach signals to all of the doors
		var doors_in_level: Array[Node] = get_doors()
		for door in doors_in_level:
			if door is Door:
				door.door_entered.connect(_on_door_entered)
		# Add the color rect offset
		#var rng = RandomNumberGenerator.new()
		#rng.seed = hash(scene_file_path)
		#color_rect.material.set_shader_parameter("offset", Vector2(rng.randf_range(-100000., 10000.), rng.randf_range(-100000., 10000.)))


func _on_door_entered(direction: Types.DoorDirection):
	# Bubble up the door entered signal to the level manager
	door_entered.emit(direction)


func initialize_level() -> void:
	var dialogue_trigger_nodes: Array[Node] = get_tree().get_nodes_in_group("dialogue_trigger")
	for node in dialogue_trigger_nodes:
		if node is DialogueTrigger:
			node.load_data_from_savefile(SaveManager.get_save_file())
	
	var progress_detector_nodes: Array[Node] = get_tree().get_nodes_in_group("progress_detector")
	for node in progress_detector_nodes:
		if node is ProgressDetector:
			node.load_data_from_savefile(SaveManager.get_save_file())


func _process(_delta: float) -> void:
	#if not Engine.is_editor_hint():
	#	color_rect.material.set_shader_parameter("camera_offset", GameManager.camera.global_position)
	pass


func get_camera_bounds() -> Rect2:
	var shape: Shape2D = camera_bounds.shape
	if shape is RectangleShape2D:
		var x: float = camera_bounds.global_position.x
		var y: float = camera_bounds.global_position.y
		var w: float = shape.size.x
		var h: float = shape.size.y
		return Rect2(x, y, w, h)
	return Rect2(0, 0, 0, 0)


func get_doors() -> Array[Node]:
	return doors.get_children()


func add_object(node: Node2D) -> void:
	objects.add_child(node)


func add_effect(node: Node2D) -> void:
	effects.add_child(node)
