@tool
class_name Room extends Node2D

signal room_door_entered(dest_room_path: String, dest_door_tag: String)

@onready var camera_bounds: CollisionShape2D = $CameraBounds/CollisionShape2D
@onready var doors: Node2D = $Doors
@onready var objects: Node2D = $Objects
@onready var effects: Node2D = $Effects
@export var section: float

func _ready() -> void:
	
	# Attach signals to all of the doors
	
	var doors_in_room = get_tree().get_nodes_in_group("door")
	for door in doors_in_room:
		door.door_entered.connect(_on_door_entered)

func _on_door_entered(dest_room_path: String, dest_door_tag: String):
	room_door_entered.emit.call_deferred(dest_room_path, dest_door_tag)

func initialize_room() -> void:
	var dialogue_trigger_nodes: Array[Node] = get_tree().get_nodes_in_group("dialogue_trigger")
	for node in dialogue_trigger_nodes:
		if node is DialogueTrigger:
			node.load_data_from_savefile(SaveManager.get_save_file())

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
