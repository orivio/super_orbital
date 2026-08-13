@tool
class_name Room
extends Node2D

signal room_door_entered(dest_room: String, dest_door_tag: String)

@export_file("ogg") var music_for_this_room: String
@export var level_metadata: LevelMeta

@onready var camera_bounds: CollisionShape2D = $CameraBounds/CollisionShape2D
@onready var doors: Node2D = $Doors
@onready var objects: Node2D = $Objects
@onready var effects: Node2D = $Effects
@onready var color_rect: ColorRect = $Background/ColorRect

func _ready() -> void:
	
	if not Engine.is_editor_hint():
		# Attach signals to all of the doors
		
		var doors_in_room = get_tree().get_nodes_in_group("door")
		for door in doors_in_room:
			door.door_entered.connect(_on_door_entered)
		
		# Add the color rect offset
		var rng = RandomNumberGenerator.new()
		rng.seed = hash(scene_file_path)
		color_rect.material.set_shader_parameter("offset", Vector2(rng.randf_range(-100000., 10000.), rng.randf_range(-100000., 10000.)))

func sync_scene_path() -> void:
	if not Engine.is_editor_hint():
		push_error("Should not have to sync scene paths at runtime!")
		return
	
	if not level_metadata:
		push_error("Missing level metadata!")
		return
	
	if not level_metadata.resource_path:
		push_error("Level metadata has not been saved")
		return
	
	if level_metadata.scene_path != scene_file_path:
		level_metadata.scene_path = scene_file_path
		ResourceSaver.save(level_metadata, level_metadata.resource_path)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			sync_scene_path()

func _on_door_entered(dest_room: String, dest_door_tag: String):
	room_door_entered.emit.call_deferred(dest_room, dest_door_tag)

func initialize_room() -> void:
	var dialogue_trigger_nodes: Array[Node] = get_tree().get_nodes_in_group("dialogue_trigger")
	for node in dialogue_trigger_nodes:
		if node is DialogueTrigger:
			node.load_data_from_savefile(SaveManager.get_save_file())
	
	var progress_detector_nodes: Array[Node] = get_tree().get_nodes_in_group("progress_detector")
	for node in progress_detector_nodes:
		if node is ProgressDetector:
			node.load_data_from_savefile(SaveManager.get_save_file())

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		color_rect.material.set_shader_parameter("camera_offset", GameManager.camera.global_position)

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
