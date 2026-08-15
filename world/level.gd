class_name Level
extends Node2D


signal level_transition_entered(direction: Types.EastWestNoneDirection)


@export var level_metadata: LevelMeta


@onready var level_transition_container: LevelTransitionContainer = $LevelTransitions
@onready var camera_bounds: CollisionShape2D = $CameraBounds/CollisionShape2D
@onready var objects: Node2D = $Objects
@onready var effects: Node2D = $Effects
@onready var color_rect: ColorRect = $Background/ColorRect


func _ready() -> void:
	# Collect level transitions at runtime and connect them to the right signals
	var level_transitions: Array[LevelTransition]
	level_transitions.assign(level_transition_container.get_level_transitions())
	for level_transition in level_transitions:
		level_transition.player_entered.connect(_on_level_transition_entered)
		level_transition.monitoring = false
		
	if not Engine.is_editor_hint():
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

func _on_level_transition_entered(direction: Types.EastWestNoneDirection) -> void:
	level_transition_entered.emit(direction)

func get_level_transition(direction: Types.EastWestNoneDirection) -> LevelTransition:
	return level_transition_container.get_level_transition(direction)

func get_camera_limits() -> Rect2:
	
	var shape: Shape2D = camera_bounds.shape
	
	if shape is RectangleShape2D:
		
		var x: float = camera_bounds.global_position.x
		var y: float = camera_bounds.global_position.y
		var w: float = shape.size.x
		var h: float = shape.size.y
		
		return Rect2(x, y, w, h)
	
	return Rect2(0, 0, 0, 0)

func initialize() -> void:
	var dialogue_trigger_nodes: Array[Node] = get_tree().get_nodes_in_group("dialogue_trigger")
	for node in dialogue_trigger_nodes:
		if node is DialogueTrigger:
			node.load_data_from_savefile(SaveManager.get_save_file())
	
	var progress_detector_nodes: Array[Node] = get_tree().get_nodes_in_group("progress_detector")
	for node in progress_detector_nodes:
		if node is ProgressDetector:
			node.load_data_from_savefile(SaveManager.get_save_file())
	
	for level_transition in level_transition_container.get_level_transitions():
		level_transition.monitoring = true

func add_object(node: Node2D) -> void:
	objects.add_child(node)

func add_effect(node: Node2D) -> void:
	effects.add_child(node)
